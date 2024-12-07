<%@ tag import="com.cal.Routes" %>

<%@tag pageEncoding="UTF-8" %>
<%@ taglib prefix="tg" tagdir="/WEB-INF/tags" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div x-data="learnerForm()" x-init="init()" x-cloak>
    <button @click="openModal" class="rounded-md bg-primary px-9 py-3 font-medium text-white ">
        Ajouter un apprenant
    </button>
    <div x-show="modalOpen" x-transition="" class="overflow-y-auto md:max-h-[80vh] fixed left-0 top-0 z-999999 flex h-full min-h-screen w-full items-center justify-center bg-black/90 px-4 py-5">
        <div @click.outside="closeModal"
        <%--         :class="{'xl:max-w-4xl': !successMessage}"--%>
             class="w-full max-w-142.5  rounded-lg bg-white px-8 py-12 text-center dark:bg-boxdark md:px-17.5 md:py-15">
            <h4 x-show="!successMessage"
                class=" mb-6 text-xl font-bold text-black dark:text-white"
                x-text="formTitle">
            </h4>
            <!-- Form -->
            <form  x-show="!successMessage" @submit.prevent="submitForm">
                <tg:x-input-form label="Prénom" name="firstname"
                                 placeholder="Entrer le prénom de l'apprenant"
                                 isRequired="true" xmodel="form.firstname" />
                <tg:x-input-form label="Nom" name="lastname"
                                 placeholder="Entrer le nom de l'apprenant"
                                 isRequired="true" xmodel="form.lastname" />
                <tg:x-input-form label="E-mail" name="email"
                                 type="email"
                                 placeholder="Entrer l'e-mail de l'apprenant"
                                 isRequired="true" xmodel="form.email" />
                <div class="mb-4 px-2">
                    <label for="levelId"
                           class="mb-3 block text-sm font-medium text-black dark:text-white"
                    >Niveau</label>
                    <select id="levelId" name="levelId" x-model="form.levelId"
                            class="relative z-20 w-full appearance-none rounded border border-stroke bg-transparent px-5 py-3 outline-none transition focus:border-primary active:border-primary dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary">
                        <option value="" class="text-body">Sélectionner un niveau
                        </option>
                        <c:forEach var="level" items="${levels}">
                            <option value="${level.id}">${level.name}</option>
                        </c:forEach>
                    </select>
                    <span x-text="errors.level" style="color: red;"></span>
                </div>
                <div class="mb-4 px-2">
                    <label for="languageId"
                           class="mb-3 block text-sm font-medium text-black dark:text-white">
                        Langue
                    </label>
                    <select id="languageId" name="languageId" x-model="form.languageId"
                            class="relative z-20 w-full appearance-none rounded border border-stroke bg-transparent px-5 py-3 outline-none transition focus:border-primary active:border-primary dark:border-form-strokedark dark:bg-form-input dark:focus:border-primary">
                        <option value="" class="text-body">Sélectionner une langue
                        </option>
                        <c:forEach var="language" items="${languages}">
                            <option value="${language.id}">${language.name}</option>
                        </c:forEach>
                    </select>
                    <span x-text="errors.language" style="color: red;"></span>
                </div>
                <div class="flex justify-end">
                    <button x-text="submitBtnText" type="submit" class="block w-full w-max rounded border border-primary bg-primary p-3 text-center font-medium text-white transition hover:bg-opacity-90">
                    </button>
                </div>

            </form>

            <!-- Success Message -->
            <div id="successMessage"  x-show="successMessage"
                 class="flex w-full"
            >
                <div
                        class="flex w-max w-max mx-auto p-4 w-full  items-center justify-center rounded-full bg-[#34D399]"
                >
                    <svg
                            width="56"
                            height="50"
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
                <div class="w-full ">
                    <h5
                            class="mb-3 text-lg font-bold text-black dark:text-[#34D399]"
                    >
                        Succès
                    </h5>
                    <p x-text="successMessage" class="text-base leading-relaxed text-body">
                    </p>
                </div>
            </div>
            <div x-show="successMessage" @click="closeModal" class="flex justify-end">
                <button type="submit" class="block w-full w-max rounded border border-primary bg-primary p-3 text-center font-medium text-white transition hover:bg-opacity-90">
                    Fermer
                </button>
            </div>

        </div>
    </div>
</div>

<script>
    document.addEventListener('alpine:init', () => {
        Alpine.data('learnerForm', () => ({
            formTitle: "Ajouter un apprenant",
            submitBtnText: "Ajouter",
            modalOpen: false,
            form: {
                id: null,
                firstname: '',
                lastname: '',
                email: '',
                languageId:null,
                levelId:null
            },
            errors: {},
            successMessage: '',

            openModal() {
                this.resetForm();
                this.modalOpen = true;
                this.successMessage = '';
            },

            closeModal() {
                this.modalOpen = false;
                this.resetForm();
                this.successMessage = '';
            },

            setForm(learner) {
                console.log(learner)
                this.form = { ...learner };
                this.formTitle = this.form.id ? "Modifier un apprenant" : "Ajouter un apprenant";
                this.submitBtnText = this.form.id ? "Sauvegarder" : "Ajouter";
                this.modalOpen = true;
            },

            resetForm() {
                this.formTitle = "Ajouter un apprenant";
                this.submitBtnText = "Ajouter";
                this.form = {
                    id: null,
                    firstname: '',
                    lastname: '',
                    email: '',
                    languageId:null,
                    levelId:null
                };
                this.errors = {};
            },

            init() {
                window.learnerForm = this.setForm.bind(this);
            },

            submitForm() {
                const data = JSON.stringify(this.form);
                console.log("Sending data:", data);
                const method = this.form.id ? 'PUT' : 'POST';

                fetch('<%=Routes.LEARNER_FORM%>', {
                    method: method,
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: data
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.errors) {
                            this.errors = data.errors;
                            console.log("Errors received:", this.errors);
                        } else {
                            const msg = this.form.id ? 'modifié' : 'ajouté';
                            this.successMessage = "L'apprenant a été " + msg + " avec succès!";
                            // Appeler la méthode globale pour rafraîchir les apprenants
                            window.refreshLearners();
                        }
                    })
                    .catch(error => console.error('Error:', error));
            },

        }));
    });
</script>
