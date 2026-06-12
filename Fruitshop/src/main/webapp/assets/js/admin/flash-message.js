document.addEventListener('DOMContentLoaded', () => {
  const flash = document.querySelector('[data-flash-message]');
  if (!flash) return;
  window.setTimeout(() => {
    flash.classList.add('flash-hide');
    try {
      const url = new URL(window.location.href);
      url.searchParams.delete('permMsg');
      window.history.replaceState({}, document.title, url.toString());
    } catch (e) {
    }
  }, 4000);
});