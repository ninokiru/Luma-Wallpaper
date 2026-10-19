using Google.Protobuf.WellKnownTypes;
using Grpc.Core;
using Lively.Common;
using Lively.Common.Helpers;
using Lively.Common.Services;
using Lively.Grpc.Common.Proto.Update;
using Lively.Models.Services;
using System;
using System.Diagnostics;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Threading;

namespace Lively.RPC
{
    internal class AppUpdateServer : UpdateService.UpdateServiceBase
    {
        private static readonly NLog.Logger Logger = NLog.LogManager.GetCurrentClassLogger();
        private readonly IAppUpdaterService updater;

        public AppUpdateServer(IAppUpdaterService updater)
        {
            this.updater = updater;
        }

        public override async Task<Empty> CheckUpdate(Empty _, ServerCallContext context)
        {
            await updater.CheckUpdate(0);
            return await Task.FromResult(new Empty());
        }

        public override async Task<GetLatestReleaseResponse> GetLatestRelease(GetLatestReleaseRequest request, ServerCallContext context)
        {
            try
            {
                var (SetupUri, SetupFileName, SetupVersion) = await updater.GetLatestRelease(request.Channel == ReleaseChannel.Beta);

                return await Task.FromResult(new GetLatestReleaseResponse()
                {
                    Url = SetupUri?.OriginalString ?? string.Empty,
                    FileName = SetupFileName ?? string.Empty,
                    Version = SetupVersion?.ToString() ?? string.Empty
                });
            }
            catch (Exception ex)
            {
                throw new RpcException(new Status(StatusCode.Internal, $"Update lookup failed: {ex.Message}"));
            }
        }

        public override Task<Empty> StartUpdate(Empty _, ServerCallContext context)
        {
            if (updater.Status != AppUpdateStatus.available)
                return Task.FromResult(new Empty());

            try
            {
                try
                {
                    // Main user interface downloads the setup into the shared temp folder.
                    // The name comes from a release asset, so it is flattened before use.
                    var fileName = Path.GetFileName(updater.LastCheckFileName);
                    if (string.IsNullOrEmpty(fileName))
                        throw new FileNotFoundException("No installer asset was found for the latest release.");

                    var filePath = Path.Combine(Constants.CommonPaths.TempDir, fileName);
                    if (!File.Exists(filePath))
                        throw new FileNotFoundException(filePath);

                    // Run setup in silent mode.
                    Process.Start(filePath, GetSetupArguments());
                    // Inno installer will auto retry, waiting for application exit.
                    App.QuitApp();
                }
                catch (Exception ex)
                {
                    Application.Current.Dispatcher.BeginInvoke(DispatcherPriority.Normal, new ThreadStart(delegate
                    {
                        MessageBox.Show($"{Properties.Resources.LivelyExceptionAppUpdateFail}\n\nException:\n{ex}", Properties.Resources.TextError, MessageBoxButton.OK, MessageBoxImage.Error);
                    }));
                }
            }
            catch (Exception ex)
            {
                Logger.Error(ex);
            }
            return Task.FromResult(new Empty());
        }

        /// <summary>
        /// The setup defaults to a per-user install, which cannot replace a per-machine
        /// one: it finds no previous registration, lays a second copy under AppData and
        /// leaves the running build at the old version. The scope therefore comes from the
        /// folder this process was started from, which is the install being updated.
        /// </summary>
        private static string GetSetupArguments()
        {
            const string silent = "/SILENT /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS";
            var installDir = Path.GetFullPath(AppDomain.CurrentDomain.BaseDirectory)
                .TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar);

            foreach (var root in new[]
            {
                Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles),
                Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86),
            })
            {
                if (string.IsNullOrEmpty(root))
                    continue;

                var prefix = Path.GetFullPath(root)
                    .TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar);
                if (installDir.Equals(prefix, StringComparison.OrdinalIgnoreCase) ||
                    installDir.StartsWith(prefix + Path.DirectorySeparatorChar, StringComparison.OrdinalIgnoreCase))
                    return silent + " /ALLUSERS";
            }

            return silent;
        }

        public override Task<UpdateResponse> GetUpdateStatus(Empty _, ServerCallContext context)
        {
            return Task.FromResult(new UpdateResponse()
            {
                Status = (UpdateStatus)((int)updater.Status),
                Changelog = updater.LastCheckChangelog ?? string.Empty,
                Url = updater.LastCheckUri?.OriginalString ?? string.Empty,
                FileName = updater.LastCheckFileName ?? string.Empty,
                Version = updater.LastCheckVersion?.ToString() ?? string.Empty,
                Time = Timestamp.FromDateTime(updater.LastCheckTime.ToUniversalTime()),
            });
        }

        public override async Task SubscribeUpdateChecked(Empty _, IServerStreamWriter<Empty> responseStream, ServerCallContext context)
        {
            try
            {
                while (!context.CancellationToken.IsCancellationRequested)
                {
                    var tcs = new TaskCompletionSource<bool>();
                    updater.UpdateChecked += Updater_UpdateChecked;
                    void Updater_UpdateChecked(object sender, AppUpdaterEventArgs e)
                    {
                        updater.UpdateChecked -= Updater_UpdateChecked;
                        tcs.TrySetResult(true);
                    }
                    using var item = context.CancellationToken.Register(() => { tcs.TrySetResult(false); });
                    await tcs.Task;

                    if (context.CancellationToken.IsCancellationRequested)
                    {
                        updater.UpdateChecked -= Updater_UpdateChecked;
                        break;
                    }

                    await responseStream.WriteAsync(new Empty());
                }
            }
            catch (Exception e)
            {
                Logger.Error(e);
            }
        }
    }
}
