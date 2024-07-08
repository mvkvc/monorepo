CtrlShiftSubmit = {
    mounted() {
      this.el.addEventListener("keydown", (e) => {
        if (e.shiftKey && e.key === 'Enter') {
          this.el.form.dispatchEvent(
            new Event('submit', {bubbles: true, cancelable: true}));
        }
      })
    }
  }