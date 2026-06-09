import { defineConfig } from "vitepress";
import { tabsMarkdownPlugin } from "vitepress-plugin-tabs";

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "Sling",
  description: "A modern and reactive backpack system for Roblox",
  base: "/sling/",
  head: [
    ["link", { rel: "icon", href: "/sling/logo.png" }]
  ],

  markdown: {
    config(md) {
      md.use(tabsMarkdownPlugin);
    }
  },

  themeConfig: {
    logo: "/logo.png",

    search: {
      provider: "local"
    },

    footer: {
      message: "Released under the MIT License.",
    },

    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: "Home", link: "/" },
      { text: "Tutorials", link: "/tut/crash-course/1-why" },
      { text: "API", link: "/api/ui" }
    ],

    sidebar: {
      "/api/": [
        {
          text: "API Reference",
          items: [
            { text: "UI", link: "/api/ui" },
            { text: "Events", link: "/api/events" },
            { text: "Themes", link: "/api/themes" },
            { text: "Topbar Icon", link: "/api/topbar-icon" }
          ]
        }
      ],
      "/tut/": [
        {
          text: "Crash Course",
          items: [
            { text: "Why", link: "/tut/crash-course/1-why" },
            { text: "Installation", link: "/tut/crash-course/2-installation" },
            { text: "Creating Category", link: "/tut/crash-course/3-category" },
            { text: "Changing Theme", link: "/tut/crash-course/4-themes" },
            { text: "Subscribing to Events", link: "/tut/crash-course/5-events" }
          ]
        },
        {
          text: "Advanced",
          items: [
            { text: "Customizing Components", link: "/tut/advanced/customizing-components" }
          ]
        }
      ]
    },

    socialLinks: [
      { icon: "github", link: "https://github.com/encodedlux/sling" }
    ]
  }
})
