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
          selected = 'viewLangue';
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
                <tgc:alerte-delete-modal/>

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
                                <tgc:add-or-update-form/>

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
                                                        class="border-b flex gap-2.5 border-[#eee] px-4 py-5 dark:border-strokedark">
                                                    <button @click="editCourse(course)"
                                                            class="text-blue-500">
                                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"
                                                             fill="currentColor" class="size-4"
                                                             title="Modifier"
                                                             width="18" height="18">
                                                            <path d="M13.488 2.513a1.75 1.75 0 0 0-2.475 0L6.75 6.774a2.75 2.75 0 0 0-.596.892l-.848 2.047a.75.75 0 0 0 .98.98l2.047-.848a2.75 2.75 0 0 0 .892-.596l4.261-4.262a1.75 1.75 0 0 0 0-2.474Z"/>
                                                            <path d="M4.75 3.5c-.69 0-1.25.56-1.25 1.25v6.5c0 .69.56 1.25 1.25 1.25h6.5c.69 0 1.25-.56 1.25-1.25V9A.75.75 0 0 1 14 9v2.25A2.75 2.75 0 0 1 11.25 14h-6.5A2.75 2.75 0 0 1 2 11.25v-6.5A2.75 2.75 0 0 1 4.75 2H7a.75.75 0 0 1 0 1.5H4.75Z"/>
                                                        </svg>
                                                    </button>

                                                    <button @click="deleteCourseForm(course)"
                                                            class="text-red-600">
                                                        <svg title="Supprimer" class="fill-current" width="18" height="18" viewBox="0 0 18 18"
                                                             fill="none" xmlns="http://www.w3.org/2000/svg">
                                                            <path d="M13.7535 2.47502H11.5879V1.9969C11.5879 1.15315 10.9129 0.478149 10.0691 0.478149H7.90352C7.05977 0.478149 6.38477 1.15315 6.38477 1.9969V2.47502H4.21914C3.40352 2.47502 2.72852 3.15002 2.72852 3.96565V4.8094C2.72852 5.42815 3.09414 5.9344 3.62852 6.1594L4.07852 15.4688C4.13477 16.6219 5.09102 17.5219 6.24414 17.5219H11.7004C12.8535 17.5219 13.8098 16.6219 13.866 15.4688L14.3441 6.13127C14.8785 5.90627 15.2441 5.3719 15.2441 4.78127V3.93752C15.2441 3.15002 14.5691 2.47502 13.7535 2.47502ZM7.67852 1.9969C7.67852 1.85627 7.79102 1.74377 7.93164 1.74377H10.0973C10.2379 1.74377 10.3504 1.85627 10.3504 1.9969V2.47502H7.70664V1.9969H7.67852ZM4.02227 3.96565C4.02227 3.85315 4.10664 3.74065 4.24727 3.74065H13.7535C13.866 3.74065 13.9785 3.82502 13.9785 3.96565V4.8094C13.9785 4.9219 13.8941 5.0344 13.7535 5.0344H4.24727C4.13477 5.0344 4.02227 4.95002 4.02227 4.8094V3.96565ZM11.7285 16.2563H6.27227C5.79414 16.2563 5.40039 15.8906 5.37227 15.3844L4.95039 6.2719H13.0785L12.6566 15.3844C12.6004 15.8625 12.2066 16.2563 11.7285 16.2563Z"
                                                                  fill=""/>
                                                            <path d="M9.00039 9.11255C8.66289 9.11255 8.35352 9.3938 8.35352 9.75942V13.3313C8.35352 13.6688 8.63477 13.9782 9.00039 13.9782C9.33789 13.9782 9.64727 13.6969 9.64727 13.3313V9.75942C9.64727 9.3938 9.33789 9.11255 9.00039 9.11255Z"
                                                                  fill=""/>
                                                            <path d="M11.2502 9.67504C10.8846 9.64692 10.6033 9.90004 10.5752 10.2657L10.4064 12.7407C10.3783 13.0782 10.6314 13.3875 10.9971 13.4157C11.0252 13.4157 11.0252 13.4157 11.0533 13.4157C11.3908 13.4157 11.6721 13.1625 11.6721 12.825L11.8408 10.35C11.8408 9.98442 11.5877 9.70317 11.2502 9.67504Z"
                                                                  fill=""/>
                                                            <path d="M6.72245 9.67504C6.38495 9.70317 6.1037 10.0125 6.13182 10.35L6.3287 12.825C6.35683 13.1625 6.63808 13.4157 6.94745 13.4157C6.97558 13.4157 6.97558 13.4157 7.0037 13.4157C7.3412 13.3875 7.62245 13.0782 7.59433 12.7407L7.39745 10.2657C7.39745 9.90004 7.08808 9.64692 6.72245 9.67504Z"
                                                                  fill=""/>
                                                        </svg>
                                                    </button>
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

<tg:footer/>
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
                if (this.isFetching) return;
                this.isFetching = true;

                const url = '${pageContext.request.contextPath}${Routes.LANG_COURSE}';
                const data = {
                    languageId: '${language.id}',
                    page: this.page,
                    pageSize: this.pageSize,
                    searchQuery: this.searchQuery
                };


                fetch(url, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(data)
                })
                    .then(response => response.json())
                    .then(data => {
                        this.courses = data.courses;
                        this.totalCourses = data.totalCourses;
                        this.page = data.page;
                        this.pageSize = data.pageSize;
                        this.isFetching = false;
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        this.isFetching = false;
                    });
            },

            init() {
                this.isFetching = false;
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
                window.courseForm(data);
            },
            deleteCourse(course) {
                const data = {
                    id: course.id,
                    name: course.name,
                };
                window.deleteCourseForm(data);
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