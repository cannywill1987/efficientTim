'use strict';

module.exports = [
  {
    id: 'tencent-skillhub',
    source: 'community',
    // 不直接写死 JSON 地址，而是运行时从首页 bundle 中解析真实资源地址。
    type: 'tencent-skillhub',
    url: 'https://skillhub.tencent.com/',
    homepage: 'https://skillhub.tencent.com/',
    tags: [ 'marketplace', 'community', 'skills' ],
    downloadUrlTemplate: 'http://lightmake.site/api/v1/download?slug={slug}',
  },
];
