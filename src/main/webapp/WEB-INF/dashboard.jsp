<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="tg" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tgr" tagdir="/WEB-INF/tags/roles" %>

<%@ page import="com.cal.Routes" %>
<!DOCTYPE html>
<html lang="fr">

<tg:head-style title="Tableau de bord">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</tg:head-style>

<body
        x-data="{ page: 'dasshboard', 'loaded': true, 'darkMode': true, 'stickyMenu': false, 'sidebarToggle': false, 'scrollTop': false }"
        x-init="
                        darkMode = JSON.parse(localStorage.getItem('darkMode'));
                        selected = 'dasshboard';
                        $watch('darkMode', value => localStorage.setItem('darkMode', JSON.stringify(value)))"
        :class="{'dark text-bodydark bg-boxdark-2': darkMode === true}">
<!-- ===== Preloader Start ===== -->
<tg:preloader />

<!-- ===== Preloader End ===== -->

<!-- ===== Page Wrapper Start ===== -->
<div class="flex h-screen overflow-hidden">
    <!-- ===== Sidebar Start ===== -->
    <tg:sidebar />

    <!-- ===== Sidebar End ===== -->

    <!-- ===== Content Area Start ===== -->
    <div
            class="relative flex flex-1 flex-col overflow-y-auto overflow-x-hidden">
        <!-- ===== Header Start ===== -->
        <tg:header />

        <!-- ===== Header End ===== -->

        <!-- ===== Main Content Start ===== -->
        <main x-data="courseUsageData">
            <div class="mx-auto max-w-screen-2xl p-4 md:p-6 2xl:p-10">
                <div
                        class="mt-4 grid grid-cols-12 gap-4 md:mt-6 md:gap-6 2xl:mt-7.5 2xl:gap-7.5">
                    <!-- ====== Chart One Start -->
                    <div
                            class="col-span-12 rounded-sm border border-stroke bg-white px-5 pb-5 pt-7.5 shadow-default dark:border-strokedark dark:bg-boxdark sm:px-7.5 "
                    >
                        <h1>Statistiques d'Utilisation des Cours</h1>

                        <form form id="filterForm" class="flex flex-wrap items-start justify-between gap-3 sm:flex-nowrap">


                                    <label for="startDate">Date de début :</label>
                                    <input type="date" id="startDate" name="startDate"
                                           x-model="startDate">

                                    <label for="endDate">Date de fin :</label>
                                    <input type="date" id="endDate" name="endDate" x-model="endDate">

                                    <button type="button" @click="fetchCourseUsage()"
                                            class="rounded-md bg-primary px-9 py-3 font-medium text-white">Afficher les
                                        Statistiques</button>

                        </form>


                        <canvas id="courseUsageChart" width="400" height="200"></canvas>

                    </div>

                    <!-- ====== Chart One End -->

                </div>
            </div>
        </main>
        <!-- ===== Main Content End ===== -->
    </div>
    <!-- ===== Content Area End ===== -->
</div>
<!-- ===== Page Wrapper End ===== -->
<tg:footer />

<script>
    document.addEventListener('alpine:init', () => {
        Alpine.data('courseUsageData', () => ({
            startDate: '',
            endDate: '',
            fetchCourseUsage() {
                const url = '<%=Routes.CURSE_USAGE%>?startDate='+this.startDate+'&endDate='+this.endDate;

                fetch(url)
                    .then(response => response.json())
                    .then(data => {
                        const courseNames = data.map(item => item.courseName);
                        const enrollmentCounts = data.map(item => item.enrollmentCount);

                        const ctx = document.getElementById('courseUsageChart').getContext('2d');
                        new Chart(ctx, {
                            type: 'bar',
                            data: {
                                labels: courseNames,
                                datasets: [{
                                    label: 'Nombre d\'Inscriptions',
                                    data: enrollmentCounts,
                                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                                    borderColor: 'rgba(75, 192, 192, 1)',
                                    borderWidth: 1
                                }]
                            },
                            options: {
                                scales: {
                                    y: {
                                        beginAtZero: true
                                    }
                                }
                            }
                        });
                    })
                    .catch(error => console.error('Erreur lors de la récupération des données :', error));
            },
            init() {
                this.fetchCourseUsage();  // Fetch data on init
            }
        }));
    });
</script>

</body>

</html>