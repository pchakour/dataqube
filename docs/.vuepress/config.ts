import { defineUserConfig, defaultTheme, SidebarItem } from 'vuepress';
import { globSync } from 'glob';
import path from 'path';
import { searchPlugin } from '@vuepress/plugin-search'
import { prismjsPlugin } from '@vuepress/plugin-prismjs'


let pluginsSidebarItems: SidebarItem[] = globSync(`${__dirname}/../documentation/parsing_tool/plugins/*`).map((dir) => {
  const pluginTypeName = path.basename(dir);
  return {
    text: pluginTypeName.charAt(0).toUpperCase() + pluginTypeName.slice(1, -1) + ' plugins',
    collapsible: true,
    link: `/documentation/parsing_tool/plugins/${pluginTypeName}/`,
    children: globSync(`${dir}/*`).sort().map((pluginFile) => {
      const pluginName = path.parse(pluginFile).name;
      return `/documentation/parsing_tool/plugins/${pluginTypeName}/${pluginName}`
    }).filter((plugin) => !plugin.endsWith('index')),
  };
});

const inputs = pluginsSidebarItems.find((type) => type.link === '/documentation/parsing_tool/plugins/inputs/')!;
pluginsSidebarItems = pluginsSidebarItems.filter((type) => type.link !== '/documentation/parsing_tool/plugins/inputs/');
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
        link: '/documentation/getting_started',
      },
    ],
    sidebar: {
      '/documentation/': [{
        text: 'Documentation',
        link: '/documentation/getting_started',
        collapsible: false,
        children: [
          {
            text: 'Getting started',
            link: '/documentation/getting_started',
          },
          {
            text: 'Parsing tool',
            collapsible: true,
            children: [
              {
                text: 'Configuration',
                link: '/documentation/parsing_tool/configuration',
              },
              ...pluginsSidebarItems,
            ]
          },
          {
            text: 'Dataqube App',
          }
        ],
      }]
    },
  }),
})