(function () {
  "use strict";

  const selector = ".reveal .plotly-stable .plotly.html-widget";
  let resizeFrame = null;

  function resizePlot(el) {
    if (!window.Plotly || !el._fullLayout) return;

    // clientWidth/clientHeight excluent la transformation CSS de RevealJS.
    const width = Math.round(el.clientWidth);
    const height = Math.round(el.clientHeight);
    if (width < 1 || height < 1) return;

    const currentWidth = Math.round(el._fullLayout.width || 0);
    const currentHeight = Math.round(el._fullLayout.height || 0);
    if (currentWidth === width && currentHeight === height) return;

    window.Plotly.relayout(el, { width: width, height: height, autosize: false });
  }

  function resizeAllPlots() {
    resizeFrame = null;
    document.querySelectorAll(selector).forEach(resizePlot);
  }

  function scheduleResize() {
    if (resizeFrame !== null) window.cancelAnimationFrame(resizeFrame);
    resizeFrame = window.requestAnimationFrame(resizeAllPlots);
  }

  window.addEventListener("resize", scheduleResize, { passive: true });

  document.addEventListener("DOMContentLoaded", function () {
    scheduleResize();
    window.setTimeout(scheduleResize, 50);
    window.setTimeout(scheduleResize, 250);

    if (window.Reveal && typeof window.Reveal.on === "function") {
      window.Reveal.on("ready", scheduleResize);
      window.Reveal.on("slidechanged", scheduleResize);
    }
  });
})();
