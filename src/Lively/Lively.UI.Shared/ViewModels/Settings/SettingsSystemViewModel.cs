using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using Lively.Common.Helpers;
using Lively.Common.Services;
using Lively.Grpc.Client;
using Lively.Models;
using Lively.Models.Enums;
using System;
using System.Globalization;
using System.Threading.Tasks;

namespace Lively.UI.Shared.ViewModels
{
    public partial class SettingsSystemViewModel : ObservableObject
    {
        private readonly IUserSettingsClient userSettings;
        private readonly IDialogService dialogService;
        private readonly IDispatcherService dispatcher;
        private readonly IFileService fileService;
        private readonly ICommandsClient commands;
        private readonly IResourceService i18n;

        public SettingsSystemViewModel(IUserSettingsClient userSettings,
            ICommandsClient commands,
            IDispatcherService dispatcher,
            IFileService fileService,
            IResourceService i18n,
            IDialogService dialogService)
        {
            this.userSettings = userSettings;
            this.commands = commands;
            this.dispatcher = dispatcher;
            this.fileService = fileService;
            this.dialogService = dialogService;
            this.i18n = i18n;

            SelectedTaskbarThemeIndex = (int)userSettings.Settings.SystemTaskbarTheme;
        }

        public bool IsTaskbarThemeSupported => Environment.OSVersion.Version < new Version(10, 0, 22621, 1343);

        private int _selectedTaskbarThemeIndex;
        public int SelectedTaskbarThemeIndex
        {
            get => _selectedTaskbarThemeIndex;
            set
            {
                if (userSettings.Settings.SystemTaskbarTheme != (TaskbarTheme)value)
                {
                    userSettings.Settings.SystemTaskbarTheme = (TaskbarTheme)value;
                    UpdateSettingsConfigFile();
                }
                SetProperty(ref _selectedTaskbarThemeIndex, value);
            }
        }

        [RelayCommand]
        private void ShowDebug()
        {
            commands.ShowDebugger();
        }

        [RelayCommand]
        private async Task ExtractLog()
        {
            var suggestedFileName = "lively_log_" + DateTime.Now.ToString("yyyyMMdd_HHmmss", CultureInfo.InvariantCulture);
            var file = await fileService.PickSaveFileAsync(suggestedFileName, [("Compressed archive", [".zip"])]);
            if (file != null)
            {
                try
                {
                    LogUtil.ExtractLogFiles(file);
                }
                catch (Exception ex)
                {
                    await dialogService.ShowDialogAsync(ex.Message, "Error", "OK");
                }
            }
        }

        public void UpdateSettingsConfigFile()
        {
            _ = dispatcher.TryEnqueue(userSettings.Save<SettingsModel>);
        }
    }
}
