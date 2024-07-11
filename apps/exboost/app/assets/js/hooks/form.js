const Form = {
  mounted() {
    this.el.addEventListener("keydown", (e) => {
      if (e.key === "Enter" && !e.shiftKey) {
        e.preventDefault();
        let content = document.getElementById("user-input").value;
        if (content !== "") {
          this.pushEvent("new_message", { message: { content: content } });
        }
      }
    });

    this.handleEvent("focus-input", (_event) => {
      document.getElementById("user-input").focus();
    });
  },
};

export default Form;
