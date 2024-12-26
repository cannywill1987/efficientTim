// 定义你的翻译
const translations = {
    'zh-CN': {
        'first_time_loading': '第一次加载需要60秒，请您稍后',
        'loading': '加载中...',
        'loading_failed': '加载失败',
        'loading_failed_retry': '加载失败，点击重试',
        'loading_failed_retry': '加载失败，点击重试',
     },
          


    'zh': { 
        'first_time_loading': '第一次加载需要60秒，请您稍后',
        'loading': '加载中...',
        'loading_failed': '加载失败',
        'loading_failed_retry': '加载失败，点击重试',
        'loading_failed_retry': '加载失败，点击重试',
     },
    'zh-hk': { 
        'first_time_loading': '第一次加載需要60秒，請您稍後',
        'loading': '加載中...',
        'loading_failed': '加載失敗',
        'loading_failed_retry': '加載失敗，點擊重試',
        'loading_failed_retry': '加載失敗，點擊重試',
},
    'en': { 
        'first_time_loading': 'First time loading takes 10 seconds, please wait',
        'loading': 'Loading...',
        'loading_failed': 'Loading failed',
        'loading_failed_retry': 'Loading failed, click to retry',
        'loading_failed_retry': 'Loading failed, click to retry',
     },
     //日语
     'ja': { 
        'first_time_loading': '初回ロードには60秒かかります。お待ちください',
        'loading': 'ロード中...',
        'loading_failed': 'ロードに失敗しました',
        'loading_failed_retry': 'ロードに失敗しました。再試行する',
        'loading_failed_retry': 'ロードに失敗しました。再試行する',
     },
     //韩语
     'ko': { 
        'first_time_loading': '첫 로드에는 60초가 걸립니다. 기다려주세요',
        'loading': '로딩 중...',
        'loading_failed': '로드 실패',
        'loading_failed_retry': '로드 실패, 다시 시도',
        'loading_failed_retry': '로드 실패, 다시 시도',
     },
     //德语
     'de': { 
        'first_time_loading': 'Erstmaliges Laden dauert 60 Sekunden, bitte warten',
        'loading': 'Laden...',
        'loading_failed': 'Laden fehlgeschlagen',
        'loading_failed_retry': 'Laden fehlgeschlagen, klicken Sie zum Wiederholen',
        'loading_failed_retry': 'Laden fehlgeschlagen, klicken Sie zum Wiederholen',
     },
     //法语
     'fr': { 
        'first_time_loading': 'Le premier chargement prend 60 secondes, veuillez patienter',
        'loading': 'Chargement...',
        'loading_failed': 'Échec du chargement',
        'loading_failed_retry': 'Échec du chargement, cliquez pour réessayer',
        'loading_failed_retry': 'Échec du chargement, cliquez pour réessayer',
     },
     //葡萄牙语
     'pt': { 
        'first_time_loading': 'O primeiro carregamento leva 60 segundos, por favor aguarde',
        'loading': 'Carregando...',
        'loading_failed': 'Falha ao carregar',
        'loading_failed_retry': 'Falha ao carregar, clique para tentar novamente',
        'loading_failed_retry': 'Falha ao carregar, clique para tentar novamente',
     },
     //俄罗斯语
     'ru': { 
        'first_time_loading': 'Первая загрузка занимает 10 секунд, пожалуйста, подождите',
        'loading': 'Загрузка...',
        'loading_failed': 'Ошибка загрузки',
        'loading_failed_retry': 'Ошибка загрузки, нажмите, чтобы повторить',
        'loading_failed_retry': 'Ошибка загрузки, нажмите, чтобы повторить',
     },
     //意大利语
     'it': { 
        'first_time_loading': 'Il primo caricamento richiede 60 secondi, attendere prego',
        'loading': 'Caricamento...',
        'loading_failed': 'Caricamento fallito',
        'loading_failed_retry': 'Caricamento fallito, fare clic per riprovare',
        'loading_failed_retry': 'Caricamento fallito, fare clic per riprovare',
     },
     //西班牙语
     'es': { 
        'first_time_loading': 'La primera carga tarda 60 segundos, espere por favor',
        'loading': 'Cargando...',
        'loading_failed': 'Error de carga',
        'loading_failed_retry': 'Error de carga, haga clic para volver a intentar',
        'loading_failed_retry': 'Error de carga, haga clic para volver a intentar',
     },
//台湾繁体
    'zh-tw': { 
        'first_time_loading': '第一次加載需要60秒，請您稍後',
        'loading': '加載中...',
        'loading_failed': '加載失敗',
        'loading_failed_retry': '加載失敗，點擊重試',
        'loading_failed_retry': '加載失敗，點擊重試',
    },

    // 其他语言...
  };
  
  // 获取浏览器的语言设置
  const language = navigator.language || navigator.userLanguage;
  
  // 选择对应的翻译
  const selectedTranslation = translations[language] || translations['en']; // 默认为英文
  
  // 定义你的 i18n.t 函数
  const i18n = {
    t: function(key) {
      return selectedTranslation[key] || key;
    }
  };