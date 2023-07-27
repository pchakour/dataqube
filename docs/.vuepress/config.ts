import { defineUserConfig, defaultTheme, SidebarItem } from 'vuepress';
import { globSync } from 'glob';
import path from 'path';
import fs from 'fs';
import { searchPlugin } from '@vuepress/plugin-search'
import { prismjsPlugin } from '@vuepress/plugin-prismjs'


let pluginsSidebarItems: SidebarItem[] = globSync(`${__dirname}/../plugins/*`).map((dir) => {
  const pluginTypeName = path.basename(dir);
  return {
    target: `/plugins/${pluginTypeName}/`,
    text: pluginTypeName.charAt(0).toUpperCase() + pluginTypeName.slice(1, -1) + ' plugins',
    collapsible: true,
    sidebarDepth: 2,
    link: `/plugins/${pluginTypeName}/`,
    children: globSync(`${dir}/*`).sort().map((pluginFile) => {
      const pluginName = path.parse(pluginFile).name;
      return `/plugins/${pluginTypeName}/${pluginName}`
    }).filter((plugin) => !plugin.endsWith('index')),
  };
});

const inputs = pluginsSidebarItems.find((type) => type.target === '/plugins/inputs/')!;
pluginsSidebarItems = pluginsSidebarItems.filter((type) => type.target !== '/plugins/inputs/');
pluginsSidebarItems.unshift(inputs);


export default defineUserConfig({
  lang: 'en-US',
  title: '',
  description: 'Just playing around',
  plugins: [
    searchPlugin({
      // options
    }),
    prismjsPlugin({
      // options
    }),
  ],
  theme: defaultTheme({
    logo: '/images/logo_dataqube.png',
    logoDark: '/images/logo_dataqube_dark.png',
    colorMode: 'light',
    navbar: [
      {
        text: 'Home',
        link: '/',
      },
      {
        text: 'Documentation',
        link: '/plugins/inputs/',
      },
    ],
    sidebar: {
      '/plugins/': [
        {
          text: 'Documentation',
          target: '/plugins/inputs/',
          collapsible: false,
          children: pluginsSidebarItems,
        }
      ]
  },
  }),
})