const TrackClientCursor = {
  mounted() {
    document.addEventListener("mousemove", (e) => {
      const mouse_x = (e.pageX / window.innerWidth) * 100;
      const mouse_y = (e.pageY / window.innerHeight) * 100;
      (this as any).pushEvent("cursor-move", { mouse_x, mouse_y });
    });
  },
};

export default TrackClientCursor;
