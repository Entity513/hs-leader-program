// モバイルメニューのトグル
const menuToggle = document.getElementById('menuToggle');
const navMenu = document.getElementById('navMenu');

if (menuToggle && navMenu) {
    menuToggle.addEventListener('click', () => {
        navMenu.classList.toggle('active');
        menuToggle.classList.toggle('active');
        // メニューが開いている時は背景スクロールを無効化
        if (navMenu.classList.contains('active')) {
            document.body.style.overflow = 'hidden';
        } else {
            document.body.style.overflow = '';
        }
    });

    // メニューリンクをクリックしたらメニューを閉じる
    const navLinks = navMenu.querySelectorAll('a');
    navLinks.forEach(link => {
        link.addEventListener('click', () => {
            navMenu.classList.remove('active');
            menuToggle.classList.remove('active');
            document.body.style.overflow = '';
        });
    });

    // メニュー外をクリックしたら閉じる
    document.addEventListener('click', (e) => {
        if (navMenu.classList.contains('active') && 
            !navMenu.contains(e.target) && 
            !menuToggle.contains(e.target)) {
            navMenu.classList.remove('active');
            menuToggle.classList.remove('active');
            document.body.style.overflow = '';
        }
    });
}

// カレンダー機能
let currentDate = new Date();
let currentYear = currentDate.getFullYear();
let currentMonth = currentDate.getMonth();

// トーナメントデータ（サンプル）
const tournamentData = {
    '2026-01-01': [
        { time: '12:30', type: 'yellow', title: 'ビギナーズ' },
        { time: '16:00', type: 'green', title: 'レギュラー' },
        { time: '19:00', type: 'green', title: 'ナイト' }
    ],
    '2026-01-04': [
        { time: '13:30', type: 'green', title: 'レギュラー' },
        { time: '16:00', type: 'green', title: 'レギュラー' },
        { time: '17:30', type: 'green', title: 'レギュラー' },
        { time: '19:00', type: 'green', title: 'ナイト' }
    ],
    '2026-01-16': [
        { time: '17:00', type: 'red', title: 'スペシャル' }
    ],
    '2026-01-20': [
        { time: '12:00', type: 'blue', title: 'ビギナーズ' },
        { time: '15:00', type: 'green', title: 'レギュラー' },
        { time: '18:00', type: 'green', title: 'ナイト' }
    ]
};

// カレンダーを生成
function generateCalendar(year, month) {
    const calendarContainer = document.getElementById('calendarContainer');
    if (!calendarContainer) return;

    const firstDay = new Date(year, month, 1).getDay();
    const daysInMonth = new Date(year, month + 1, 0).getDate();
    const daysInPrevMonth = new Date(year, month, 0).getDate();

    // 曜日ヘッダー
    const weekDays = ['日', '月', '火', '水', '木', '金', '土'];
    calendarContainer.innerHTML = '';

    // 曜日ヘッダーを追加
    weekDays.forEach(day => {
        const dayHeader = document.createElement('div');
        dayHeader.className = 'calendar-day calendar-day-header';
        dayHeader.textContent = day;
        calendarContainer.appendChild(dayHeader);
    });

    // 前月の日付
    for (let i = firstDay - 1; i >= 0; i--) {
        const day = daysInPrevMonth - i;
        const dayElement = createDayElement(year, month - 1, day, true);
        calendarContainer.appendChild(dayElement);
    }

    // 今月の日付
    const today = new Date();
    for (let day = 1; day <= daysInMonth; day++) {
        const isToday = year === today.getFullYear() && 
                       month === today.getMonth() && 
                       day === today.getDate();
        const dayElement = createDayElement(year, month, day, false, isToday);
        calendarContainer.appendChild(dayElement);
    }

    // 次月の日付（カレンダーを埋めるため）
    const totalCells = calendarContainer.children.length;
    const remainingCells = 42 - totalCells; // 6週間分
    for (let day = 1; day <= remainingCells; day++) {
        const dayElement = createDayElement(year, month + 1, day, true);
        calendarContainer.appendChild(dayElement);
    }

    // 月表示を更新
    const monthDisplay = document.getElementById('currentMonth');
    if (monthDisplay) {
        monthDisplay.textContent = `${year}年${String(month + 1).padStart(2, '0')}月`;
    }
}

// 日付要素を作成
function createDayElement(year, month, day, isOtherMonth, isToday = false) {
    const dayElement = document.createElement('div');
    dayElement.className = 'calendar-day';
    
    if (isOtherMonth) {
        dayElement.classList.add('other-month');
    }
    
    if (isToday) {
        dayElement.classList.add('today');
    }

    const dateStr = `${year}-${String(month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
    dayElement.textContent = day;

    // トーナメントがある場合は表示
    if (tournamentData[dateStr]) {
        tournamentData[dateStr].forEach(tournament => {
            const tournamentElement = document.createElement('div');
            tournamentElement.className = `calendar-tournament ${tournament.type}`;
            tournamentElement.textContent = tournament.time;
            tournamentElement.title = `${tournament.time} ${tournament.title}`;
            dayElement.appendChild(tournamentElement);
        });
    }

    return dayElement;
}

// 前の月
const prevMonthBtn = document.getElementById('prevMonth');
if (prevMonthBtn) {
    prevMonthBtn.addEventListener('click', () => {
        currentMonth--;
        if (currentMonth < 0) {
            currentMonth = 11;
            currentYear--;
        }
        generateCalendar(currentYear, currentMonth);
    });
}

// 次の月
const nextMonthBtn = document.getElementById('nextMonth');
if (nextMonthBtn) {
    nextMonthBtn.addEventListener('click', () => {
        currentMonth++;
        if (currentMonth > 11) {
            currentMonth = 0;
            currentYear++;
        }
        generateCalendar(currentYear, currentMonth);
    });
}

// 今日のトーナメントを表示
function displayTodayTournaments() {
    const today = new Date();
    const todayStr = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, '0')}-${String(today.getDate()).padStart(2, '0')}`;
    
    const todayList = document.getElementById('todayTournamentList');
    if (!todayList) return;

    // サンプルデータ（実際のデータに置き換える）
    const todayTournaments = [
        { time: '12:30', title: 'ビギナーズトーナメント', fee: '¥1,000', prize: '¥10,000' },
        { time: '16:00', title: 'レギュラートーナメント', fee: '¥3,000', prize: '¥30,000' },
        { time: '19:00', title: 'ナイトトーナメント', fee: '¥5,000', prize: '¥50,000' }
    ];

    todayList.innerHTML = '';
    todayTournaments.forEach(tournament => {
        const item = document.createElement('div');
        item.className = 'tournament-item today';
        item.innerHTML = `
            <div class="tournament-time">${tournament.time}</div>
            <div class="tournament-info">
                <h4>${tournament.title}</h4>
                <p>参加費：${tournament.fee} / 賞金：${tournament.prize}</p>
            </div>
        `;
        todayList.appendChild(item);
    });
}

// トーナメントリストビューを生成
function generateTournamentListView() {
    const listView = document.getElementById('tournamentListView');
    if (!listView) return;

    // サンプルデータ（実際のデータに置き換える）
    const tournaments = [
        { date: '2026-01-01', time: '12:30', title: 'ビギナーズトーナメント', fee: '¥1,000', prize: '¥10,000' },
        { date: '2026-01-01', time: '16:00', title: 'レギュラートーナメント', fee: '¥3,000', prize: '¥30,000' },
        { date: '2026-01-01', time: '19:00', title: 'ナイトトーナメント', fee: '¥5,000', prize: '¥50,000' },
        { date: '2026-01-02', time: '13:00', title: 'レギュラートーナメント', fee: '¥3,000', prize: '¥30,000' },
        { date: '2026-01-02', time: '18:00', title: 'ナイトトーナメント', fee: '¥5,000', prize: '¥50,000' }
    ];

    listView.innerHTML = '';
    tournaments.forEach(tournament => {
        const item = document.createElement('div');
        item.className = 'tournament-item';
        const date = new Date(tournament.date);
        const dateStr = `${date.getMonth() + 1}/${date.getDate()}`;
        item.innerHTML = `
            <div class="tournament-time">${tournament.time}</div>
            <div class="tournament-info">
                <h4>${dateStr} ${tournament.title}</h4>
                <p>参加費：${tournament.fee} / 賞金：${tournament.prize}</p>
            </div>
        `;
        listView.appendChild(item);
    });
}

// スムーススクロール
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        const href = this.getAttribute('href');
        if (href === '#' || href === '#tournament-more' || href === '#food-detail' || 
            href === '#recruit-detail' || href === '#recruit-line' || href === '#ring-game') {
            return; // これらのリンクは処理しない
        }
        
        e.preventDefault();
        const target = document.querySelector(href);
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// ヘッダーのスクロール効果
let lastScroll = 0;
const header = document.querySelector('.header');

window.addEventListener('scroll', () => {
    const currentScroll = window.pageYOffset;
    
    if (currentScroll > 100) {
        header.classList.add('scrolled');
    } else {
        header.classList.remove('scrolled');
    }
    
    lastScroll = currentScroll;
});

// 初期化
document.addEventListener('DOMContentLoaded', () => {
    generateCalendar(currentYear, currentMonth);
    displayTodayTournaments();
    generateTournamentListView();
});
