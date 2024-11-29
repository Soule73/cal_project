<%@ tag import="com.cal.Routes" %>

<%@tag pageEncoding="UTF-8" %>
<%@ taglib prefix="tg" tagdir="/WEB-INF/tags" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div x-data="courseForm()" x-init="init()" x-cloak>
<button @click="modalOpen = true" class="rounded-md bg-primary px-9 py-3 font-medium text-white ">
    Ajouter un cours
</button>
<div x-show="modalOpen" x-transition="" class="overflow-y-auto md:max-h-[80vh] fixed left-0 top-0 z-999999 flex h-full min-h-screen w-full items-center justify-center bg-black/90 px-4 py-5">
    <div @click.outside="modalOpen = false" class="w-full max-w-142.5  xl:max-w-4xl rounded-lg bg-white px-8 py-12 text-center dark:bg-boxdark md:px-17.5 md:py-15">
        <h4 x-show="!successMessage" class=" mb-6 text-xl font-bold text-black dark:text-white">
            Langue : <c:out value="${language.name}"/> | Ajouter un cours

        </h4>
        <!-- Form -->
        <form  x-show="!successMessage" @submit.prevent="submitForm">
            <div class="xl:grid xl:grid-cols-2 grid">
                <tg:x-input-form
                        label="Nom"
                        name="name"
                        placeholder="Entrer le nom du cours"
                        isRequired="true"
                        xmodel="form.name"
                />
                <tg:x-input-form
                        label="Identifiant"
                        name="identifier"
                        placeholder="Entrer l'identifiant"
                        isRequired="true"
                        xmodel="form.identifier"
                />
                <div class="mb-4 px-2">
                    <label for="level"
                           class="block text-sm font-bold">Niveau</label>
                    <select id="level" name="level" x-model="form.level"
                            class="relative z-20 w-full appearance-none rounded border border-stroke bg-transparent px-5 py-3 outline-none transition focus:border-primary active:border-primary dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary">
                        <option value="" class="text-body">Sélectionner un niveau
                        </option>
                        <c:forEach var="level" items="${levels}">
                            <option value="${level.id}">${level.name}</option>
                        </c:forEach>
                    </select>
                    <span x-text="errors.level"
                          style="color: red;"></span>
                </div>
                <div class="mb-4 px-2">
                    <label for="level"
                           class="block text-sm font-bold">Salle de cours</label>
                    <select id="room" name="room" x-model="form.room"
                            class="relative z-20 w-full appearance-none rounded border border-stroke bg-transparent px-5 py-3 outline-none transition focus:border-primary active:border-primary dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary">
                        <option value="" class="text-body">Sélectionner un niveau
                        </option>
                        <c:forEach var="room" items="${rooms}">
                            <option value="${room.id}">${room.name}</option>
                        </c:forEach>
                    </select>
                    <span x-text="errors.room"
                          style="color: red;"></span>
                </div>
                <div class="mb-4 px-2">
                    <label for="subscription"
                           class="block text-sm font-bold">Abonnement</label>
                    <select id="subscription" name="subscription" x-model="form.subscription"
                            class="relative z-20 w-full appearance-none rounded border border-stroke bg-transparent px-5 py-3 outline-none transition focus:border-primary active:border-primary dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary">
                        <option value="" class="text-body">Sélectionner un niveau
                        </option>
                        <c:forEach var="subscription" items="${subscriptions}">
                            <option value="${subscription.id}">${subscription.name}</option>
                        </c:forEach>
                    </select>
                    <span x-text="errors.subscription"
                          style="color: red;"></span>
                </div>
                <tg:x-input-form
                        label="Type de Cours"
                        name="typeOfCourse"
                        placeholder="Entrer le type de cours"
                        isRequired="true"
                        xmodel="form.typeOfCourse"/>
                <tg:x-input-form
                        label="Description"
                        name="description"
                        type="textarea"
                        placeholder="Entrer la description"
                        xmodel="form.description"

                />

                <tg:x-input-form
                        label="Équipement Spécifique"
                        name="specificEquipment"
                        type="textarea"
                        placeholder="Entrer les équipements spécifiques"
                        xmodel="form.specificEquipment"
                />
            </div>
            <input type="hidden"
                   id="languageId"
                   name="languageId"
                   value="${language.getId()}"
                   x-model="form.languageId">



            <div class="flex justify-end">
                <button type="submit" class="block w-full w-max rounded border border-primary bg-primary p-3 text-center font-medium text-white transition hover:bg-opacity-90">
                    Ajouter
                </button>
            </div>

        </form>

        <!-- Success Message -->
        <div id="successMessage"  x-show="successMessage"
             class="flex w-full mb-4 border-l-6 border-[#34D399] bg-[#34D399] bg-opacity-[15%] px-7 py-8 shadow-md dark:bg-[#1B1B24] dark:bg-opacity-30 md:p-9"
        >
            <div
                    class="mr-5 flex h-9 w-full max-w-[36px] items-center justify-center rounded-lg bg-[#34D399]"
            >
                <svg
                        width="16"
                        height="12"
                        viewBox="0 0 16 12"
                        fill="none"
                        xmlns="http://www.w3.org/2000/svg"
                >
                    <path
                            d="M15.2984 0.826822L15.2868 0.811827L15.2741 0.797751C14.9173 0.401867 14.3238 0.400754 13.9657 0.794406L5.91888 9.45376L2.05667 5.2868C1.69856 4.89287 1.10487 4.89389 0.747996 5.28987C0.417335 5.65675 0.417335 6.22337 0.747996 6.59026L0.747959 6.59029L0.752701 6.59541L4.86742 11.0348C5.14445 11.3405 5.52858 11.5 5.89581 11.5C6.29242 11.5 6.65178 11.3355 6.92401 11.035L15.2162 2.11161C15.5833 1.74452 15.576 1.18615 15.2984 0.826822Z"
                            fill="white"
                            stroke="white"
                    ></path>
                </svg>
            </div>
            <div class="w-full">
                <h5
                        class="mb-3 text-lg font-bold text-black dark:text-[#34D399]"
                >
                    Succès
                </h5>
                <p x-text="successMessage" class="text-base leading-relaxed text-body">
                </p>
            </div>
        </div>
        <div x-show="successMessage" @click="modalOpen = false" class="flex justify-end">
            <button type="submit" class="block w-full w-max rounded border border-primary bg-primary p-3 text-center font-medium text-white transition hover:bg-opacity-90">
                Fermer
            </button>
        </div>

    </div>
</div>
</div>

<script>
    document.addEventListener('alpine:init', () => {
        Alpine.data('courseForm', () => ({
            modalOpen: false,
            form: {id:null, languageId: '${language.id}', name: '', identifier: '', description: '', specificEquipment: '', typeOfCourse: '' },
            errors: {},
            successMessage: '',

            openModal() {
                this.resetForm();
                this.modalOpen = true;
            },

            closeModal() {
                this.modalOpen = false;
                this.resetForm();
            },

            setForm(course) {
                this.form = { ...course };
                this.modalOpen = true;
            },

            resetForm() {
                this.form = { id: null, languageId: 1, name: '', identifier: '', description: '', specificEquipment: '', typeOfCourse: '' };
                this.errors = {};
                this.successMessage = '';
            },

            init(){
                window.courseForm = this.setForm.bind(this);

            },

            submitForm() {
                console.log("Sending data:", this.form);
                const method = this.form.id ? 'PUT' : 'POST';

                fetch('<%=Routes.COURSE_FORM%>', {
                    method: method,
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(this.form)
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.errors) {
                            this.errors = data.errors;
                            console.log("Errors received:", this.errors);
                        } else {
                            this.successMessage = 'Le cours a été ajouté avec succès!';
                            // this.modalOpen = false;
                            // Réinitialiser le formulaire
                            this.form = { languageId: this.form.languageId, name: '', identifier: '', description: '', specificEquipment: '', typeOfCourse: '' };
                            this.errors = {};

                            // Appeler la méthode globale pour rafraîchir les cours
                            window.refreshCourses();

                        }
                    })
                    .catch(error => console.error('Error:', error));
            },

        }));
    });
</script>

