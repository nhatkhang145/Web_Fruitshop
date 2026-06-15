document.addEventListener('DOMContentLoaded', function () {
    const menuBar = document.querySelector('.content nav .bx.bx-menu');
    const sidebar = document.querySelector('.sidebar');

    if (menuBar && sidebar) {
        menuBar.addEventListener('click', function () {
            sidebar.classList.toggle('close');
        });
    }

    window.addEventListener('resize', function () {
        if (window.innerWidth < 768) {
            if (sidebar) sidebar.classList.add('close');
        } else {
            if (sidebar) sidebar.classList.remove('close');
        }
    });

    if (window.innerWidth < 768 && sidebar) {
        sidebar.classList.add('close');
    }

    const profileBtn = document.getElementById('profileBtn');
    const profileDropdown = document.getElementById('profileDropdown');
    const notifBtn = document.getElementById('notifBtn');
    const notifDropdown = document.getElementById('notifDropdown');

    if (profileBtn && profileDropdown) {
        profileBtn.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            profileDropdown.classList.toggle('show');
            if (notifDropdown) notifDropdown.classList.remove('show');
        });
    }

    if (notifBtn && notifDropdown) {
        notifBtn.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            notifDropdown.classList.toggle('show');
            if (profileDropdown) profileDropdown.classList.remove('show');
        });
    }

    document.addEventListener('click', function (e) {
        if (profileDropdown && profileDropdown.classList.contains('show')) {
            if (!profileDropdown.contains(e.target) && e.target !== profileBtn) {
                profileDropdown.classList.remove('show');
            }
        }
        if (notifDropdown && notifDropdown.classList.contains('show')) {
            if (!notifDropdown.contains(e.target) && e.target !== notifBtn) {
                notifDropdown.classList.remove('show');
            }
        }
    });

    const toggler = document.getElementById('theme-toggle');

    if (localStorage.getItem('theme') === 'dark') {
        document.body.classList.add('dark');
        if (toggler) toggler.checked = true;
    }

    if (toggler) {
        toggler.addEventListener('change', function () {
            if (this.checked) {
                document.body.classList.add('dark');
                localStorage.setItem('theme', 'dark');
            } else {
                document.body.classList.remove('dark');
                localStorage.setItem('theme', 'light');
            }
        });
    }
});
