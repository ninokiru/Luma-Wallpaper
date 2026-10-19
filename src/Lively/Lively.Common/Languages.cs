using Lively.Models;
using System;
using System.Collections.ObjectModel;
using System.Linq;

namespace Lively.Common
{
    public static class Languages
    {
        //  Luma ships two languages. Upstream carried 47, most of them machine translated and
        //  half empty, and each one costs a resources.resw in the UI and a .resources.dll in the
        //  core. Anything outside this list falls back to the system language, which resolves to
        //  English below.
        private readonly static LanguageModel[] supportedLanguages = [
            new LanguageModel("English", "en-US"),
            new LanguageModel("Tiếng Việt", "vi-VN"), // Vietnamese
        ];

        public static ReadOnlyCollection<LanguageModel> SupportedLanguages => Array.AsReadOnly(supportedLanguages);
    }
}
