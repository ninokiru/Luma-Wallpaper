using CommunityToolkit.Mvvm.ComponentModel;
using Lively.Common.Services;
using Lively.Grpc.Client;
using Lively.Models;
using Lively.Models.Enums;

namespace Lively.UI.Shared.ViewModels
{
    public partial class SettingsScreensaverViewModel : ObservableObject
    {
        private readonly IUserSettingsClient userSettings;
        private readonly IDispatcherService dispatcher;

        public SettingsScreensaverViewModel(IUserSettingsClient userSettings, IDispatcherService dispatcher)
        {
            this.userSettings = userSettings;
            this.dispatcher = dispatcher;

            IsFadeIn = userSettings.Settings.ScreensaverFadeIn;
            IsLockOnResume = userSettings.Settings.ScreensaverLockOnResume;
            Volume = userSettings.Settings.ScreensaverGlobalVolume;
            SelectedScreensaverWaitIndex = (int)userSettings.Settings.ScreensaverIdleDelay;
        }

        private bool _isLockOnResume;
        public bool IsLockOnResume
        {
            get => _isLockOnResume;
            set
            {
                if (userSettings.Settings.ScreensaverLockOnResume != value)
                {
                    userSettings.Settings.ScreensaverLockOnResume = value;
                    UpdateSettingsConfigFile();
                }
                SetProperty(ref _isLockOnResume, value);
            }
        }

        private bool _isFadeIn;
        public bool IsFadeIn
        {
            get => _isFadeIn;
            set
            {
                if (userSettings.Settings.ScreensaverFadeIn != value)
                {
                    userSettings.Settings.ScreensaverFadeIn = value;
                    UpdateSettingsConfigFile();
                }
                SetProperty(ref _isFadeIn, value);
            }
        }

        private int _volume;
        public int Volume
        {
            get => _volume;
            set
            {
                if (userSettings.Settings.ScreensaverGlobalVolume != value)
                {
                    userSettings.Settings.ScreensaverGlobalVolume = value;
                    UpdateSettingsConfigFile();
                }
                SetProperty(ref _volume, value);
            }
        }

        private int _selectedScreensaverWaitIndex;
        public int SelectedScreensaverWaitIndex
        {
            get => _selectedScreensaverWaitIndex;
            set
            {
                if (userSettings.Settings.ScreensaverIdleDelay != (ScreensaverIdleTime)value)
                {
                    userSettings.Settings.ScreensaverIdleDelay = (ScreensaverIdleTime)value;
                    UpdateSettingsConfigFile();
                }
                SetProperty(ref _selectedScreensaverWaitIndex, value);
            }
        }

        private void UpdateSettingsConfigFile()
        {
            dispatcher.TryEnqueue(userSettings.Save<SettingsModel>);
        }
    }
}
