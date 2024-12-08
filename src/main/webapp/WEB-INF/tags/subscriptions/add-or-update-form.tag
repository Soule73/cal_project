<%@ tag import="com.cal.Routes" %>

<%@tag pageEncoding="UTF-8" %>
<%@ taglib prefix="tg" tagdir="/WEB-INF/tags" %>

<div x-data="subscriptionForm()" x-init="init()" x-cloak>
    <button @click="openModal" class="rounded-md bg-primary px-9 py-3 font-medium text-white">
        Ajouter un abonnement
    </button>
    <div x-show="modalOpen" x-transition="" class="overflow-y-auto md:max-h-[80vh] fixed left-0 top-0 z-999999 flex h-full min-h-screen w-full items-center justify-center bg-black/90 px-4 py-5" x-cloak>
        <div @click.outside="closeModal" class="w-full max-w-142.5 rounded-lg bg-white px-8 py-12 text-center dark:bg-boxdark md:px-17.5 md:py-15">
            <h4 x-show="!successMessage" class="mb-6 text-xl font-bold text-black dark:text-white" x-text="formTitle"></h4>
            <!-- Form -->
            <form @submit.prevent="submitForm" x-show="!successMessage">
                <input type="hidden" x-model="form.id">
                <tg:x-input-form label="Nom de l'abonnement" name="name" placeholder="Entrer le nom de l'abonnement" isRequired="true" xmodel="form.name" />
                <tg:x-input-form label="Prix" name="price" placeholder="Entrer le prix de l'abonnement" isRequired="true" type="number" xmodel="form.price" />
                <tg:x-input-form type="textarea" label="Description" name="description" placeholder="Entrer la description de l'abonnement" isRequired="false" xmodel="form.description" />
                <tg:x-input-form type="textarea" label="Conditions d'accès" name="accessConditions" placeholder="Entrer les conditions d'accès" isRequired="false" xmodel="form.accessConditions" />
                <tg:x-input-form label="Type" name="type" placeholder="Entrer le type de l'abonnement" isRequired="true" xmodel="form.type" />
                <tg:x-input-form label="Statut" name="status" placeholder="Entrer le statut de l'abonnement" isRequired="true" xmodel="form.status" />
                <div class="flex justify-end mt-4">
                    <button x-text="submitBtnText" type="submit" class="block w-full w-max rounded border border-primary bg-primary p-3 text-center font-medium text-white transition hover:bg-opacity-90"></button>
                </div>
            </form>

            <!-- Success Message -->
            <div id="successMessage" x-show="successMessage" class="flex w-full">
                <div class="flex w-max p-4 w-full items-center justify-center rounded-full bg-[#34D399]">
                    <svg width="56" height="50" viewBox="0 0 16 12" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M15.2984 0.826822L15.2868 0.811827L15.2741 0.797751C14.9173 0.401867 14.3238 0.400754 13.9657 0.794406L5.91888 9.45376L2.05667 5.2868C1.69856 4.89287 1.10487 4.89389 0.747996 5.28987C0.417335 5.65675 0.417335 6.22337 0.747996 6.59026L0.747959 6.59029L0.752701 6.59541L4.86742 11.0348C5.14445 11.3405 5.52858 11.5 5.89581 11.5C6.29242 11.5 6.65178 11.3355 6.92401 11.035L15.2162 2.11161C15.5833 1.74452 15.576 1.18615 15.2984 0.826822Z" fill="white" stroke="white"></path>
                    </svg>
                </div>
                <div class="w-full">
                    <h5 class="mb-3 text-lg font-bold text-black dark:text-[#34D399]">Succès</h5>
                    <p x-text="successMessage" class="text-base leading-relaxed text-body"></p>
                </div>
            </div>
            <div x-show="successMessage" @click="closeModal" class="flex justify-end mt-4">
                <button type="button" class="block w-full w-max rounded border border-primary bg-primary p-3 text-center font-medium text-white transition hover:bg-opacity-90">
                    Fermer
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('alpine:init', () => {
        Alpine.data('subscriptionForm', () => ({
            formTitle: "Ajouter un abonnement",
            submitBtnText: "Ajouter",
            modalOpen: false,
            form: {
                id: null,
                name: '',
                price: '',
                description: '',
                accessConditions: '',
                type: '',
                status: ''
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

            setForm(subscription) {
                this.form = { ...subscription };
                this.formTitle = this.form.id ? "Modifier un abonnement" : "Ajouter un abonnement";
                this.submitBtnText = this.form.id ? "Sauvegarder" : "Ajouter";
                this.modalOpen = true;
            },

            resetForm() {
                this.formTitle = "Ajouter un abonnement";
                this.submitBtnText = "Ajouter";
                this.form = {
                    id: null,
                    name: '',
                    price: '',
                    description: '',
                    accessConditions: '',
                    type: '',
                    status: ''
                };
                this.errors = {};
            },

            init() {
                window.subscriptionForm = this.setForm.bind(this);
            },

            submitForm() {
                const data = JSON.stringify(this.form);
                const method = this.form.id ? 'PUT' : 'POST';

                fetch('<%=Routes.SUBCRIPTION_FORM%>', {
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
                            console.log(data.errors)
                        } else {
                            this.successMessage = this.form.id ? "L'abonnement a été mis à jour avec succès!" : "L'abonnement a été ajouté avec succès!";
                            // Appeler la méthode globale pour rafraîchir les abonnements
                            window.refreshSubscriptions();
                        }
                    })
                    .catch(error => console.error('Error:', error));
            },
        }));
    });
</script>
