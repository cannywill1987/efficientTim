'use strict';

const path = require('path');
const { execFile } = require('child_process');

module.exports = app => {
  return {
    schedule: {
      // 每天凌晨 3 点跑一轮同步，尽量避开白天桌面端使用高峰。
      cron: '0 0 3 * * *',
      type: 'all',
    },
    async task() {
      // schedule 只负责触发 crawler，抓取和入库细节都放在独立脚本里维护。
      const scriptPath = path.join(app.baseDir, 'crawlBin/skillhub/skillhubCrawler.js');
      await new Promise((resolve, reject) => {
        execFile('node', [ scriptPath ], { cwd: app.baseDir }, error => {
          if (error) {
            app.logger.error('SkillHubSyncSchedule failed: %s', error.stack || error.message);
            reject(error);
            return;
          }
          resolve();
        });
      });
    },
  };
};
