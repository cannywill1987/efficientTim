/**
 * 文件类型：组件
 * 文件作用：渲染 Continue 主输入框底部工具栏，承接模型选择、上下文、图片、语音录入和发送动作。
 * 主要职责：把用户在工具栏里的交互转换为编辑器内容变化或 Flutter 宿主消息。
 */
import {
  AtSymbolIcon,
  LightBulbIcon as LightBulbIconOutline,
  MicrophoneIcon,
  PhotoIcon,
  XMarkIcon,
} from "@heroicons/react/24/outline";
import {
  LightBulbIcon as LightBulbIconSolid,
  StopIcon as StopIconSolid,
} from "@heroicons/react/24/solid";
import { InputModifiers } from "core";
import {
  modelSupportsImages,
  modelSupportsReasoning,
} from "core/llm/autodetect";
import { memo, useContext, useEffect, useRef, useState } from "react";
import { useAppLanguage } from "../../context/AppLanguage";
import { IdeMessengerContext } from "../../context/IdeMessenger";
import { useAppDispatch, useAppSelector } from "../../redux/hooks";
import { selectUseActiveFile } from "../../redux/selectors";
import { selectSelectedChatModel } from "../../redux/slices/configSlice";
import { setHasReasoningEnabled } from "../../redux/slices/sessionSlice";
import { setReasoningSetting } from "../../redux/slices/uiSlice";
import { exitEdit } from "../../redux/thunks/edit";
import { getMetaKeyLabel, isMetaEquivalentKeyPressed } from "../../util";
import { ToolTip } from "../gui/Tooltip";
import ModelSelect from "../modelSelection/ModelSelect";
import { ModeSelect } from "../ModeSelect";
import { Button } from "../ui";
import { useFontSize } from "../ui/font";
import ContextStatus from "./ContextStatus";
import HoverItem from "./InputToolbar/HoverItem";
import { useMainEditor } from "./TipTapEditor/MainEditorProvider";

type VoiceRecordingState = "idle" | "recording" | "transcribing";
const VOICE_RECORDING_MAX_SECONDS = 30;

export interface ToolbarOptions {
  hideUseCodebase?: boolean;
  hideImageUpload?: boolean;
  hideAddContext?: boolean;
  enterText?: string;
  hideSelectModel?: boolean;
}

interface InputToolbarProps {
  onEnter?: (modifiers: InputModifiers) => void;
  onAddContextItem?: () => void;
  onClick?: () => void;
  onImageFileSelected?: (file: File) => void;
  hidden?: boolean;
  activeKey: string | null;
  toolbarOptions?: ToolbarOptions;
  disabled?: boolean;
  isMainInput?: boolean;
}

function InputToolbar(props: InputToolbarProps) {
  const dispatch = useAppDispatch();
  const ideMessenger = useContext(IdeMessengerContext);
  const fileInputRef = useRef<HTMLInputElement | null>(null);
  const { mainEditor } = useMainEditor();
  const [voiceState, setVoiceState] = useState<VoiceRecordingState>("idle");
  const [recordingSeconds, setRecordingSeconds] = useState(0);
  const defaultModel = useAppSelector(selectSelectedChatModel);
  const useActiveFile = useAppSelector(selectUseActiveFile);
  const isInEdit = useAppSelector((store) => store.session.isInEdit);
  const codeToEdit = useAppSelector((store) => store.editModeState.codeToEdit);
  const hasReasoningEnabled = useAppSelector(
    (store) => store.session.hasReasoningEnabled,
  );
  const isEnterDisabled =
    props.disabled || (isInEdit && codeToEdit.length === 0);

  const supportsImages =
    defaultModel &&
    modelSupportsImages(
      defaultModel.provider,
      defaultModel.model,
      defaultModel.title,
      defaultModel.capabilities,
    );

  const supportsReasoning = modelSupportsReasoning(defaultModel);

  const smallFont = useFontSize(-2);
  const tinyFont = useFontSize(-3);
  const isVoiceBusy = voiceState !== "idle";

  useEffect(() => {
    if (voiceState !== "recording") {
      return;
    }

    const timer = window.setInterval(() => {
      setRecordingSeconds((seconds) =>
        Math.min(seconds + 1, VOICE_RECORDING_MAX_SECONDS),
      );
    }, 1000);
    return () => window.clearInterval(timer);
  }, [voiceState]);

  useEffect(() => {
    if (
      voiceState === "recording" &&
      recordingSeconds >= VOICE_RECORDING_MAX_SECONDS
    ) {
      void handleStopVoiceRecording();
    }
  }, [recordingSeconds, voiceState]);

  const handleStartVoiceRecording = async (event: any) => {
    event.stopPropagation();
    if (isVoiceBusy) {
      return;
    }

    setRecordingSeconds(0);
    try {
      // 录音由 Flutter 宿主侧工具类完成，Web GUI 只保留轻量状态和内联控制条。
      const response = (await ideMessenger.request(
        "appAi/startVoiceRecording" as any,
        undefined as any,
      )) as any;
      if (response?.status === "error") {
        throw new Error(response.error ?? "Voice recording failed");
      }
      setVoiceState("recording");
    } catch (error) {
      setVoiceState("idle");
      const message =
        error instanceof Error ? error.message : "Voice recording failed";
      ideMessenger.post("showToast", ["error", message]);
    }
  };

  const handleStopVoiceRecording = async (event?: any) => {
    event?.stopPropagation?.();
    if (voiceState !== "recording") {
      return;
    }

    setVoiceState("transcribing");
    try {
      const response = (await ideMessenger.request(
        "appAi/stopVoiceRecording" as any,
        undefined as any,
      )) as any;
      if (response?.status === "error") {
        throw new Error(response.error ?? "Voice transcription failed");
      }

      const content = response?.content;
      const text =
        typeof content === "string" ? content : content?.text?.toString();
      if (text?.trim()) {
        mainEditor?.chain().focus("end").insertContent(text.trim()).run();
      } else if (!content?.cancelled) {
        ideMessenger.post("showToast", [
          "warning",
          "No speech text was recognized",
        ]);
      }
    } catch (error) {
      const message =
        error instanceof Error ? error.message : "Voice transcription failed";
      ideMessenger.post("showToast", ["error", message]);
    } finally {
      setVoiceState("idle");
      setRecordingSeconds(0);
    }
  };

  const handleCancelVoiceRecording = async (event: any) => {
    event.stopPropagation();
    if (voiceState === "idle") {
      return;
    }

    try {
      await ideMessenger.request(
        "appAi/cancelVoiceRecording" as any,
        undefined as any,
      );
    } catch (error) {
      const message =
        error instanceof Error ? error.message : "Cancel recording failed";
      ideMessenger.post("showToast", ["error", message]);
    } finally {
      setVoiceState("idle");
      setRecordingSeconds(0);
    }
  };

  return (
    <>
      <div
        onClick={props.onClick}
        className={`find-widget-skip bg-vsc-input-background flex select-none flex-row items-center justify-between gap-1 pt-1 ${props.hidden ? "pointer-events-none h-0 cursor-default opacity-0" : "pointer-events-auto mt-2 cursor-text opacity-100"}`}
        style={{
          fontSize: smallFont,
        }}
      >
        <div className="xs:gap-1.5 flex flex-row items-center gap-1">
          {!isInEdit && (
            <ToolTip place="top" content="Select Mode">
              <HoverItem className="!p-0">
                <ModeSelect />
              </HoverItem>
            </ToolTip>
          )}
          <ToolTip place="top" content="Select Model">
            <HoverItem className="!p-0">
              <ModelSelect />
            </HoverItem>
          </ToolTip>
          <div className="xs:flex text-description -mb-1 hidden items-center transition-colors duration-200">
            {props.toolbarOptions?.hideImageUpload ||
              (supportsImages && (
                <>
                  <input
                    type="file"
                    ref={fileInputRef}
                    style={{ display: "none" }}
                    accept=".jpg,.jpeg,.png,.gif,.svg,.webp"
                    onChange={(e) => {
                      const files = e.target?.files ?? [];
                      for (const file of files) {
                        props.onImageFileSelected?.(file);
                      }
                      if (fileInputRef.current) {
                        fileInputRef.current.value = "";
                      }
                    }}
                  />

                  <ToolTip place="top" content="Attach Image">
                    <HoverItem className="">
                      <PhotoIcon
                        className="h-3 w-3 hover:brightness-125"
                        onClick={(e) => {
                          fileInputRef.current?.click();
                        }}
                      />
                    </HoverItem>
                  </ToolTip>
                </>
              ))}
            {props.toolbarOptions?.hideAddContext || (
              <ToolTip place="top" content="Attach Context">
                <HoverItem onClick={props.onAddContextItem}>
                  <AtSymbolIcon className="h-3 w-3 hover:brightness-125" />
                </HoverItem>
              </ToolTip>
            )}
            {supportsReasoning && (
              <HoverItem
                onClick={() => {
                  dispatch(setHasReasoningEnabled(!hasReasoningEnabled));
                  if (defaultModel?.title) {
                    dispatch(
                      setReasoningSetting({
                        modelTitle: defaultModel.title,
                        enabled: !hasReasoningEnabled,
                      }),
                    );
                  }
                }}
              >
                <ToolTip
                  place="top"
                  content={
                    hasReasoningEnabled
                      ? "Disable model reasoning"
                      : "Enable model reasoning"
                  }
                >
                  {hasReasoningEnabled ? (
                    <LightBulbIconSolid className="h-3 w-3 brightness-200 hover:brightness-150" />
                  ) : (
                    <LightBulbIconOutline className="h-3 w-3 hover:brightness-150" />
                  )}
                </ToolTip>
              </HoverItem>
            )}
          </div>
        </div>

        <div
          className="text-description flex items-center gap-2 whitespace-nowrap"
          style={{
            fontSize: tinyFont,
          }}
        >
          {!isInEdit && <ContextStatus />}
          {!props.toolbarOptions?.hideUseCodebase && !isInEdit && (
            <div className="hidden transition-colors duration-200 hover:underline md:flex">
              <HoverItem
                className={
                  props.activeKey === "Meta" ||
                  props.activeKey === "Control" ||
                  props.activeKey === "Alt"
                    ? "underline"
                    : ""
                }
                onClick={(e) =>
                  props.onEnter?.({
                    useCodebase: false,
                    noContext: !useActiveFile,
                  })
                }
              >
                <ToolTip
                  place="top-end"
                  content={`${
                    useActiveFile
                      ? "Send Without Active File"
                      : "Send With Active File"
                  } (${getMetaKeyLabel()}⏎)`}
                >
                  <span>
                    {getMetaKeyLabel()}⏎{" "}
                    {useActiveFile ? "No active file" : "Active file"}
                  </span>
                </ToolTip>
              </HoverItem>
            </div>
          )}
          {isInEdit && (
            <HoverItem
              className="hidden hover:underline sm:flex"
              onClick={async () => {
                void dispatch(exitEdit({}));
                ideMessenger.post("focusEditor", undefined);
              }}
            >
              <span>
                <i>Esc</i> to exit Edit
              </span>
            </HoverItem>
          )}
          {props.isMainInput && (
            <ToolTip
              place="top"
              content={isVoiceBusy ? "Voice input is active" : "Record voice"}
            >
              <Button
                variant="secondary"
                size="sm"
                data-testid="record-voice-input-button"
                onClick={handleStartVoiceRecording}
                disabled={isVoiceBusy || props.disabled}
              >
                <MicrophoneIcon
                  className={`h-3.5 w-3.5 ${isVoiceBusy ? "animate-pulse" : ""}`}
                />
              </Button>
            </ToolTip>
          )}
          <ToolTip place="top" content="Send (⏎)">
            <Button
              variant={props.isMainInput ? "primary" : "secondary"}
              size="sm"
              data-testid="submit-input-button"
              onClick={async (e) => {
                if (props.onEnter) {
                  props.onEnter({
                    useCodebase: false,
                    noContext: useActiveFile
                      ? isMetaEquivalentKeyPressed(e as any) || e.altKey
                      : !(isMetaEquivalentKeyPressed(e as any) || e.altKey),
                  });
                }
              }}
              disabled={isEnterDisabled}
            >
              <span className="hidden md:inline">
                ⏎ {props.toolbarOptions?.enterText ?? "Enter"}
              </span>
              <span className="md:hidden">⏎</span>
            </Button>
          </ToolTip>
        </div>
      </div>
      {props.isMainInput && voiceState !== "idle" && (
        <VoiceRecorderPanel
          seconds={recordingSeconds}
          maxSeconds={VOICE_RECORDING_MAX_SECONDS}
          state={voiceState}
          onCancel={handleCancelVoiceRecording}
          onStop={handleStopVoiceRecording}
        />
      )}
    </>
  );
}

function formatVoiceDuration(seconds: number) {
  const minutes = Math.floor(seconds / 60)
    .toString()
    .padStart(2, "0");
  const restSeconds = Math.floor(seconds % 60)
    .toString()
    .padStart(2, "0");
  return `${minutes}:${restSeconds}`;
}

// 录音条保持在输入框内联展示，避免 Flutter 侧弹窗破坏 HTML 面板的沉浸感。
function VoiceRecorderPanel(props: {
  seconds: number;
  maxSeconds: number;
  state: VoiceRecordingState;
  onCancel: (event: any) => void;
  onStop: (event: any) => void;
}) {
  const { strings } = useAppLanguage();
  const isTranscribing = props.state === "transcribing";
  const remainingSeconds = Math.max(props.maxSeconds - props.seconds, 0);

  return (
    <div className="mt-2 overflow-hidden rounded-[22px] border border-zinc-700/60 bg-[#14161b] px-5 py-4 text-zinc-100 shadow-[0_18px_45px_rgba(0,0,0,0.35)]">
      <div className="grid grid-cols-[70px_1fr_70px] items-end gap-4">
        <button
          type="button"
          className="flex appearance-none flex-col items-center gap-2 border-0 bg-transparent p-0 text-zinc-300 transition-transform duration-150 hover:scale-105 hover:text-white disabled:scale-100 disabled:opacity-35"
          onClick={props.onCancel}
          disabled={isTranscribing}
          aria-label={strings.voiceCancelRecording}
        >
          <span className="flex h-14 w-14 items-center justify-center rounded-full bg-zinc-700/90 shadow-inner shadow-white/5 ring-1 ring-white/5">
            <XMarkIcon className="h-8 w-8 stroke-[1.8]" />
          </span>
          <span className="text-[13px] font-semibold tracking-wide">
            {strings.cancel}
          </span>
        </button>

        <div className="min-w-0 pb-1 text-center">
          <div className="mb-3 flex items-center justify-center gap-2 text-base font-semibold tracking-wide text-blue-400">
            <MicrophoneIcon className="h-5 w-5 stroke-[2.1]" />
            <span>
              {isTranscribing
                ? strings.voiceTranscribing
                : strings.voiceRecording}
            </span>
            <span className="tabular-nums">
              {formatVoiceDuration(remainingSeconds)}
            </span>
          </div>
          <VoiceWaveform isTranscribing={isTranscribing} />
          <div className="mt-3 truncate text-[13px] font-medium text-zinc-400">
            {isTranscribing
              ? strings.voiceTranscribingHint
              : strings.voiceStopHint}
          </div>
        </div>

        <button
          type="button"
          className="flex appearance-none flex-col items-center gap-2 border-0 bg-transparent p-0 text-zinc-50 transition-transform duration-150 hover:scale-105 disabled:scale-100 disabled:opacity-60"
          onClick={props.onStop}
          disabled={isTranscribing}
          aria-label={strings.voiceStopRecording}
        >
          <span className="flex h-14 w-14 items-center justify-center rounded-full bg-blue-500 shadow-[0_10px_24px_rgba(59,130,246,0.35)] ring-1 ring-blue-300/35">
            <StopIconSolid className="h-6 w-6" />
          </span>
          <span className="text-[13px] font-semibold tracking-wide">
            {isTranscribing
              ? strings.voiceTranscribingAction
              : strings.voiceEnd}
          </span>
        </button>
      </div>
    </div>
  );
}

// 使用 SVG 直接绘制波形，避免 Tailwind arbitrary class 在插件构建环境中漏生成导致波浪不可见。
function VoiceWaveform(props: { isTranscribing: boolean }) {
  const baseHeights = [
    8, 12, 10, 18, 24, 16, 30, 20, 36, 14, 26, 34, 18, 44, 22, 32, 48, 20, 38,
    28, 52, 30, 42, 22, 34, 46, 24, 36, 18, 30, 14, 24, 10, 20, 8, 16, 12, 22,
    9, 18, 7, 14, 10, 16, 8, 12,
  ];
  const centerY = 28;

  return (
    <div className="mx-auto h-12 max-w-[380px] overflow-hidden">
      <svg
        aria-hidden="true"
        className="h-full w-full"
        preserveAspectRatio="xMidYMid meet"
        viewBox="0 0 360 56"
      >
        <defs>
          <linearGradient id="voice-wave-active" x1="0" x2="1" y1="0" y2="0">
            <stop offset="0%" stopColor="#60a5fa" />
            <stop offset="55%" stopColor="#3b82f6" />
            <stop offset="100%" stopColor="#64748b" />
          </linearGradient>
        </defs>
        {baseHeights.map((height, index) => {
          const x = 6 + index * 7.55;
          const isActive = index < 30;
          const animatedHeight = Math.max(7, height * 0.52);
          const delay = `${(index % 9) * 0.08}s`;

          return (
            <rect
              key={index}
              fill={isActive ? "url(#voice-wave-active)" : "#5f636b"}
              height={height}
              opacity={isActive ? 1 : 0.55}
              rx="2"
              width="3.2"
              x={x}
              y={centerY - height / 2}
            >
              {!props.isTranscribing && (
                <>
                  <animate
                    attributeName="height"
                    begin={delay}
                    dur="0.95s"
                    repeatCount="indefinite"
                    values={`${height};${animatedHeight};${height}`}
                  />
                  <animate
                    attributeName="y"
                    begin={delay}
                    dur="0.95s"
                    repeatCount="indefinite"
                    values={`${centerY - height / 2};${
                      centerY - animatedHeight / 2
                    };${centerY - height / 2}`}
                  />
                </>
              )}
            </rect>
          );
        })}
      </svg>
    </div>
  );
}

function shallowToolbarOptionsEqual(a?: ToolbarOptions, b?: ToolbarOptions) {
  if (a === b) return true;
  if (!a || !b) return false;
  return (
    a.hideAddContext === b.hideAddContext &&
    a.hideImageUpload === b.hideImageUpload &&
    a.hideUseCodebase === b.hideUseCodebase &&
    a.hideSelectModel === b.hideSelectModel &&
    a.enterText === b.enterText
  );
}

export default memo(
  InputToolbar,
  (prev, next) =>
    prev.hidden === next.hidden &&
    prev.disabled === next.disabled &&
    prev.isMainInput === next.isMainInput &&
    prev.activeKey === next.activeKey &&
    shallowToolbarOptionsEqual(prev.toolbarOptions, next.toolbarOptions),
);
