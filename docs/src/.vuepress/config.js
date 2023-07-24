const { description } = require('../../package');
const { globSync } = require('glob');
const path = require('path');
const fs = require('fs');

let pluginsSidebarItems = globSync(`${__dirname}/../plugins/*`).map((dir) => {
  const pluginTypeName = path.basename(dir);
  return {
    path: `/plugins/${pluginTypeName}/`,
    title: pluginTypeName.charAt(0).toUpperCase() + pluginTypeName.slice(1, -1) + ' plugins',
    sidebarDepth: 2,
    children: globSync(`${dir}/*`).sort().map((pluginFile) => {
      const pluginName = path.parse(pluginFile).name;
      return {
        title: pluginName,
        path: `/plugins/${pluginTypeName}/${pluginName}.md`,
      }
    }).filter((plugin) => plugin.title !== 'index'),
  };
});

const inputs = pluginsSidebarItems.find((type) => type.path === '/plugins/inputs/');
pluginsSidebarItems = pluginsSidebarItems.filter((type) => type.path !== '/plugins/inputs/');
pluginsSidebarItems.unshift(inputs);

fs.writeFileSync('toremove.log', JSON.stringify(pluginsSidebarItems));

module.exports = {
  /**
   * Ref：https://v1.vuepress.vuejs.org/config/#title
   */
  title: '',
  /**
   * Ref：https://v1.vuepress.vuejs.org/config/#description
   */
  description: description,

  /**
   * Extra tags to be injected to the page HTML `<head>`
   *
   * ref：https://v1.vuepress.vuejs.org/config/#head
   */
  head: [
    ['meta', { name: 'theme-color', content: '#3eaf7c' }],
    ['meta', { name: 'apple-mobile-web-app-capable', content: 'yes' }],
    ['meta', { name: 'apple-mobile-web-app-status-bar-style', content: 'black' }]
  ],

  /**
   * Theme configuration, here is the default theme configuration for VuePress.
   *
   * ref：https://v1.vuepress.vuejs.org/theme/default-theme-config.html
   */
  themeConfig: {
    repo: '',
    colorModeSwitch: true,
    colorMode: 'dark',
    logo: '/images/logo_dataqube.png',
    editLinks: false,
    docsDir: '',
    editLinkText: '',
    lastUpdated: false,
    nav: [
      {
        text: 'Documentation',
        link: '/plugins/inputs/',
      },
    ],
    sidebar: [
      {
        title: 'Documentation',
        path: '/plugins/inputs/',
        collapsable: false,
        children: pluginsSidebarItems,
      }
    ]
  },

  /**
   * Apply plugins，ref：https://v1.vuepress.vuejs.org/zh/plugin/
   */
  plugins: [
    '@vuepress/plugin-last-updated',
    '@vuepress/plugin-back-to-top',
    '@vuepress/plugin-medium-zoom',
  ]
};
