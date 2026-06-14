import { createContext, useContext, useEffect, useMemo, useState } from "react";
import type { ReactNode } from "react";

type AppLanguageStrings = {
  cancel: string;
  voiceRecording: string;
  voiceTranscribing: string;
  voiceStopHint: string;
  voiceTranscribingHint: string;
  voiceCancelRecording: string;
  voiceStopRecording: string;
  voiceTranscribingAction: string;
  voiceEnd: string;
};

type AppLanguageContextValue = {
  languageCode: string;
  strings: AppLanguageStrings;
};

type AppLanguagePayload = {
  languageCode?: string;
  strings?: Partial<AppLanguageStrings>;
};

const fallbackStrings: AppLanguageStrings = {
  cancel: "Cancel",
  voiceRecording: "Recording",
  voiceTranscribing: "Transcribing",
  voiceStopHint: "Tap end to finish recording. Cancel will discard it.",
  voiceTranscribingHint: "Converting to text...",
  voiceCancelRecording: "Cancel recording",
  voiceStopRecording: "End recording",
  voiceTranscribingAction: "Transcribing",
  voiceEnd: "End",
};

const AppLanguageContext = createContext<AppLanguageContextValue>({
  languageCode: "en",
  strings: fallbackStrings,
});

function readInitialLanguage(): AppLanguagePayload {
  return (window as any).__timehelloAppLanguage ?? {};
}

function mergeLanguagePayload(
  payload: AppLanguagePayload,
): AppLanguageContextValue {
  return {
    languageCode: payload.languageCode || "en",
    strings: {
      ...fallbackStrings,
      ...(payload.strings ?? {}),
    },
  };
}

export function AppLanguageProvider(props: { children: ReactNode }) {
  const [language, setLanguage] = useState<AppLanguageContextValue>(() =>
    mergeLanguagePayload(readInitialLanguage()),
  );

  useEffect(() => {
    const setAppLanguage = (payload: AppLanguagePayload) => {
      (window as any).__timehelloAppLanguage = payload;
      setLanguage(mergeLanguagePayload(payload));
    };

    (window as any).setLanguage = setAppLanguage;

    const listener = (event: MessageEvent) => {
      if (event.data?.messageType !== "appAi/setLanguage") {
        return;
      }
      setAppLanguage((event.data?.data ?? {}) as AppLanguagePayload);
    };

    window.addEventListener("message", listener);
    return () => {
      window.removeEventListener("message", listener);
      if ((window as any).setLanguage === setAppLanguage) {
        delete (window as any).setLanguage;
      }
    };
  }, []);

  const value = useMemo(() => language, [language]);

  return (
    <AppLanguageContext.Provider value={value}>
      {props.children}
    </AppLanguageContext.Provider>
  );
}

export function useAppLanguage() {
  return useContext(AppLanguageContext);
}
