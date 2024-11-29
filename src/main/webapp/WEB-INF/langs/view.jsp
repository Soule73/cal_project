<%@ page import="com.cal.Routes" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<%@ taglib prefix="tg" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tgc" tagdir="/WEB-INF/tags/courses" %>
<!DOCTYPE html>
<html lang="fr">
<tg:head-style title="Détails de langue"/>

<body
        x-data="{ page: 'viewLangue', 'loaded': true, 'darkMode': true, 'stickyMenu': false, 'sidebarToggle': false, 'scrollTop': false }"
        x-init="
          darkMode = JSON.parse(localStorage.getItem('darkMode'));
          $watch('darkMode', value => localStorage.setItem('darkMode', JSON.stringify(value)))"
        :class="{'dark text-bodydark bg-boxdark-2': darkMode === true}">
<!-- ===== Preloader Start ===== -->
<tg:preloader/>
<!-- ===== Preloader End ===== -->

<!-- ===== Page Wrapper Start ===== -->
<div class="flex h-screen overflow-hidden">

    <!-- ===== Sidebar Start ===== -->
    <tg:sidebar/>
    <!-- ===== Sidebar End ===== -->

    <!-- ===== Content Area Start ===== -->
    <div
            class="relative flex flex-1 flex-col overflow-y-auto overflow-x-hidden">
        <!-- ===== Header Start ===== -->
        <tg:header/>
        <!-- ===== Header End ===== -->

        <!-- ===== Main Content Start ===== -->
        <main>
            <div class="mx-auto max-w-screen-2xl p-4 md:p-6 2xl:p-10">
                <!-- Breadcrumb Start -->
                <tg:breadcrumb name="Détails de langue"/>
                <!-- Breadcrumb End -->

                <!-- ====== Subscrition Start -->
                <div
                        class="rounded-sm border border-stroke bg-white px-5 pb-2.5 pt-6 shadow-default dark:border-strokedark dark:bg-boxdark sm:px-7.5 xl:pb-1">
                    <h4 class=" mb-1 text-xl font-bold text-black dark:text-white">
                        Langue : <c:out value="${language.name}"/>

                    </h4>
                    <div class="max-w-full py-6 overflow-x-auto">

                        <!-- ====== courses Table Start -->
                        <div x-data="dataTable()" x-ref="courseTable" x-init="init"
                                class="rounded-sm border-t border-stroke bg-white pb-2.5 pt-6 dark:border-strokedark dark:bg-boxdark xl:pb-1">
                           <div class=" pb-2 ">
                               <h4 class="mb-1 text-xl font-bold text-black dark:text-white">
                                   Cours
                               </h4>
                           </div>
                            <div class="flex flex-wrap justify-between items-center pb-2 ">

                                <div class=" max-w-md ">
                                    <input
                                            class="w-full rounded border-[1.5px] border-stroke bg-transparent px-5 py-3
                                            font-normal text-black outline-none transition focus:border-primary
                                            active:border-primary disabled:cursor-default disabled:bg-whiter dark:border-form-strokedark
                                            dark:bg-form-input dark:text-white dark:focus:border-primary"
                                            x-model="searchQuery"
                                            @input.debounce.500="fetchData"
                                            placeholder="Recherche..."
                                            type="search"
                                            title="Search within table"
                                    >
                                </div>
                                <tgc:add-form/>

                            </div>
                            <div >
                                <div class="max-w-full pb-6 overflow-x-auto">
                                    <table class="w-full table-auto">
                                        <thead>
                                        <tr class="bg-gray-2 text-left dark:bg-meta-4">
                                            <th class="min-w-[220px] px-4 py-4 font-medium text-black dark:text-white xl:pl-11">
                                                Identifiant
                                            </th>
                                            <th class="min-w-[150px] px-4 py-4 font-medium text-black dark:text-white">
                                                Nom
                                            </th>
                                            <th class="min-w-[150px] px-4 py-4 font-medium text-black dark:text-white">
                                                Niveau
                                            </th>
                                            <th class="min-w-[150px] px-4 py-4 font-medium text-black dark:text-white">
                                                Description
                                            </th>
                                            <th class="min-w-[150px] px-4 py-4 font-medium text-black dark:text-white">
                                                Type de Cours
                                            </th>
                                            <th
                                                    class="min-w-[150px] px-4 py-4 font-medium text-black dark:text-white">
                                                Action
                                            </th>
                                        </tr>
                                        </thead>
                                        <tbody id="courses-list">
                                        <template x-for="course in courses" :key="course.id">
                                            <tr>
                                                <td class="border-b border-[#eee] px-4 py-5 dark:border-strokedark">
                                                    <p class="text-black dark:text-white" x-text="course.identifier"></p>
                                                </td>
                                                <td class="border-b border-[#eee] px-4 py-5 dark:border-strokedark">
                                                    <p class="inline-flex px-3 py-1 text-sm font-medium text-success" x-text="course.name"></p>
                                                </td>
                                                <td class="border-b border-[#eee] px-4 py-5 dark:border-strokedark">
                                                    <p class="text-black dark:text-white" x-text="course.level"></p>
                                                </td>
                                                <td class="border-b border-[#eee] px-4 py-5 dark:border-strokedark">
                                                    <p class="text-black dark:text-white" x-text="course.description"></p>
                                                </td>
                                                <td class="border-b border-[#eee] px-4 py-5 dark:border-strokedark">
                                                    <p class="text-black dark:text-white" x-text="course.typeOfCourse"></p>
                                                </td>
                                                <td
                                                        class="border-b border-[#eee] px-4 py-5 dark:border-strokedark">
                                                    <button @click="editCourse(course)"
                                                            class="text-blue-500">Modifier</button>
                                                </td>
                                            </tr>
                                        </template>
                                        </tbody>
                                    </table>
                                </div>

                                <div>
                                    <button @click="prevPage" :disabled="page === 1" class="px-4 py-2 bg-gray-200 dark:bg-gray-700 rounded-md">Précédent</button>
                                    <span x-text="page" class="px-4 py-2"></span>
                                    <button @click="nextPage" :disabled="page >= totalPages" class="px-4 py-2 bg-gray-200 dark:bg-gray-700 rounded-md">Suivant</button>
                                </div>
                            </div>

                        </div>
                        <!-- ====== courses Table End -->
                    </div>
                </div>
                <!-- ====== Subscrition End -->



            </div>
        </main>
        <!-- ===== Main Content End ===== -->
    </div>
    <!-- ===== Content Area End ===== -->
</div>
<!-- ===== Page Wrapper End ===== -->

<script defer src="${pageContext.request.contextPath}/bundle.js"></script>
<script>
    document.addEventListener('alpine:init', () => {
        Alpine.data('dataTable', () => ({
            courses: [],
            searchQuery: '',
            page: 1,
            pageSize: 10,
            totalCourses: 0,
            isFetching:false,

            get totalPages() {
                return Math.ceil(this.totalCourses / this.pageSize);
            },

            fetchData() {
                // Empêcher les appels multiples si une requête est déjà en cours
                if (this.isFetching) return;
                this.isFetching = true;

                const url = '${Routes.LANG_COURSE}';
                const data = {
                    languageId: '${language.id}',
                    page: this.page,
                    pageSize: this.pageSize,
                    searchQuery: this.searchQuery
                };

                console.log("Sending data:", data); // Pour vérifier les données envoyées

                fetch(url, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(data)
                })
                    .then(response => response.json())
                    .then(data => {
                        console.log(data)
                        this.courses = data.courses;
                        this.totalCourses = data.totalCourses;
                        this.page = data.page;
                        this.pageSize = data.pageSize;
                        this.isFetching = false; // Réinitialiser l'état de la requête
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        this.isFetching = false; // Réinitialiser l'état de la requête même en cas d'erreur
                    });
            },

            init() {
                this.isFetching = false; // Initialiser l'état de la requête
                this.fetchData();
                window.refreshCourses = this.fetchData.bind(this);
            },

            editCourse(course) {
                const data = {
                    id: course.id,
                    languageId: course.languageId,
                    name: course.name,
                    level: course.levelId,
                    room: course.roomId,
                    subscription: course.subscriptionId,
                    identifier: course.identifier,
                    description: course.description,
                    specificEquipment: course.specificEquipment,
                    typeOfCourse: course.typeOfCourse,
                };
                // Remplir le formulaire de modification avec les valeurs du cours sélectionné
                window.courseForm(data);
            },

            prevPage() {
                if (this.page > 1) {
                    this.page--;
                    this.fetchData();
                }
            },

            nextPage() {
                if (this.page < this.totalPages) {
                    this.page++;
                    this.fetchData();
                }
            }
        }));
    });
</script>
</body>
</html>