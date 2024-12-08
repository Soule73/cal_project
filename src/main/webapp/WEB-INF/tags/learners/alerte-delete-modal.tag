<%@ tag import="com.cal.Routes" %>
<%@tag pageEncoding="utf-8" %>

<div x-data="deleteLearnerForm()" x-init="init()" x-cloak>
    <div x-show="modalOpen" x-transition="" class="fixed left-0 top-0 z-999999 flex h-full min-h-screen w-full items-center justify-center bg-black/90 px-4 py-5" x-cloak>
        <div @click.outside="modalOpen = false" class="w-full max-w-142.5 rounded-lg bg-white px-8 py-12 text-center dark:bg-boxdark md:px-17.5 md:py-15">
            <span x-show="!successMessage" class="mx-auto inline-block">
                <svg width="60" height="60" viewBox="0 0 60 60" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <rect opacity="0.1" width="60" height="60" rx="30" fill="#DC2626"></rect>
                    <path d="M30 27.2498V29.9998V27.2498ZM30 35.4999H30.0134H30ZM20.6914 41H39.3086C41.3778 41 42.6704 38.7078 41.6358 36.8749L32.3272 20.3747C31.2926 18.5418 28.7074 18.5418 27.6728 20.3747L18.3642 36.8749C17.3296 38.7078 18.6222 41 20.6914 41Z" stroke="#DC2626" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"></path>
                </svg>
            </span>
            <h3 x-show="!successMessage" x-text="modalTitle" class="mt-5.5 capitalize pb-2 text-xl font-bold text-black dark:text-white sm:text-2xl"></h3>
            <p x-show="!successMessage" x-text="modalDesc" class="mb-10 font-medium"></p>
            <div x-show="!successMessage" class="-mx-3 flex flex-wrap gap-y-4">
                <div class="w-full px-3 2xsm:w-1/2">
                    <button @click="modalOpen = false" class="block w-full rounded border border-stroke bg-gray p-3 text-center font-medium text-black transition hover:border-meta-1 hover:bg-meta-1 hover:text-white dark:border-strokedark dark:bg-meta-4 dark:text-white dark:hover:border-meta-1 dark:hover:bg-meta-1">
                        Annuler
                    </button>
                </div>
                <div class="w-full px-3 2xsm:w-1/2">
                    <button @click="submitForm" x-text="submitBtnText" class="block w-full rounded border border-meta-1 bg-meta-1 p-3 text-center font-medium text-white transition hover:bg-opacity-90"></button>
                </div>
            </div>

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
        Alpine.data('deleteLearnerForm', () => ({
            modalTitle: "êtes-vous sûr de vouloir supprimer ?",
            submitBtnText: "supprimer",
            modalOpen: false,
            modalDesc: "",
            deleteForm: {
                id: null, name: ""
            },
            errors: {},
            successMessage: '',

            openModal() {
                this.resetDeleteForm();
                this.modalOpen = true;
                this.successMessage = '';
            },

            closeModal() {
                this.modalOpen = false;
                this.resetDeleteForm();
                this.successMessage = '';
            },

            setDeleteForm(learner) {
                console.log("learner : " + learner);
                this.deleteForm = { ...learner };

                this.modalDesc = "L'apprenant : " + this.deleteForm.name;
                this.modalOpen = true;
            },

            resetDeleteForm() {
                this.modalTitle = "êtes-vous sûr de vouloir supprimer";
                this.submitBtnText = "supprimer";
                this.deleteForm = {
                    id: null,
                };
                this.errors = {};
            },

            init() {
                window.deleteLearnerForm = this.setDeleteForm.bind(this);
            },

            submitForm() {
                const data = JSON.stringify(this.deleteForm);
                console.log("Sending data:", data);

                fetch('<%=Routes.LEARNER_FORM %>', {
                    method: "DELETE",
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
                            this.resetDeleteForm();
                            this.successMessage = "L'apprenant a été supprimé avec succès!";
                            // Appeler la méthode globale pour rafraîchir les apprenants
                            window.refreshLearners();
                        }
                    })
                    .catch(error => console.error('Error:', error));
            },

        }));
    });
</script>
