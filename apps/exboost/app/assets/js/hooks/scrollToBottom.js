const ScrollToBottom = {
  mounted() {
    this.handleEvent("scroll-to-bottom", (_event) => {
      this.el.scrollTo(0, this.el.scrollHeight);
    });
  },
};

export default ScrollToBottom;
