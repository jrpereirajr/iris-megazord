
const menuZord = () => {
  const sideBar = document.getElementById('sideBarMenu');
  sideBar.innerHTML = `
    <div class="dlabnav-scroll">
				<ul class="metismenu" id="menu">
                    <li><a class="has-arrow " href="javascript:void()" aria-expanded="false">
							<i class="fas fa-chart-line"></i>
							<span class="nav-text">System Monitor</span>
						</a>
                        <ul aria-expanded="false">
							<li><a href="index.csp">System Dashboard</a></li>
							<li><a href="systemprocesses.csp">System Processes</a></li>
						</ul>
                    </li>

                    <li><a class="has-arrow " href="javascript:void()" aria-expanded="true">
						<i class="fas fa-history"></i>
							<span class="nav-text">History Monitor</span>
						</a>
                        <ul aria-expanded="false">
                            <li><a href="historylicense.csp">License</a></li>
							<li><a href="historydatabase.csp">Database Growth</a></li>
							<li><a href="historycspsessions.csp">CSP Sessions</a></li>
                        </ul>
                    </li>

					<li><a class="has-arrow " href="javascript:void()" aria-expanded="true">
						<i class="far fa-comment-alt"></i>
							<span class="nav-text">Message Viewer</span>
						</a>
                        <ul aria-expanded="false">
                            <li><a href="messageviewer.csp">Message Viewer</a></li>
                        </ul>
                    </li>

					<li><a class="has-arrow " href="javascript:void()" aria-expanded="true">
						<i class="fas fa-search"></i>
							<span class="nav-text">ZPM Explorer</span>
						</a>
                        <ul aria-expanded="false">
                            <li><a href="overview.html">Overview</a></li>
							<li><a href="explorer.html">Explorer</a></li>
							<li><a href="installed.html">Installed</a></li>
                        </ul>
                    </li>

					<li><a class="has-arrow " href="javascript:void()" aria-expanded="true">
						<i class="fas fa-plug"></i>
							<span class="nav-text">Plug & Play</span>
						</a>
                        <ul aria-expanded="false">
                            <li><a href="resources/plugins/fillow/app-profile.html">Profile</a></li>
                        </ul>
                    </li>

                </ul>
			</div>
  `;

}

menuZord();