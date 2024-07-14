const ResetInput = {
  mounted() {
    this.handleEvent("reset-input", (_event) => {
      this.el.value = "";
    });
  },
};

export default ResetInput;
