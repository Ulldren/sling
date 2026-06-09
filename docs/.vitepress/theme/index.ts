import DefaultTheme, { VPButton } from "vitepress/theme";
import { enhanceAppWithTabs } from "vitepress-plugin-tabs/client";
import "./style.css";

export default {
  extends: DefaultTheme,
  enhanceApp({ app }) {
    app.component("Button", VPButton);
    enhanceAppWithTabs(app);
  }
};
