document.addEventListener('DOMContentLoaded', () => {
  const flashes = document.querySelectorAll('[data-flash-message]');
  if (flashes.length === 0) return;
  
  window.setTimeout(() => {
    flashes.forEach(flash => flash.classList.add('flash-hide'));
    try {
      const url = new URL(window.location.href);
      url.searchParams.delete('permMsg');
      url.searchParams.delete('success');
      url.searchParams.delete('error');
      window.history.replaceState({}, document.title, url.toString());
    } catch (e) {
      console.error(e);
    }
  }, 5000);
});