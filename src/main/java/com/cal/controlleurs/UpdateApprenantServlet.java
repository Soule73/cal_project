package com.cal.controlleurs;


import com.cal.Routes;
import com.cal.models.Learner;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.NoResultException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;

import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;


@WebServlet(name = "apprenant.update", urlPatterns = Routes.LEARNER_UPDATE)
public class UpdateApprenantServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = (EntityManagerFactory) getServletContext().getAttribute("EntityManagerFactory");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        EntityManager em = emf.createEntityManager();

        try {
            Learner apprenant = em.find(Learner.class, id);
            if (apprenant == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Learner not found");
                return;
            }
            request.setAttribute("apprenant", apprenant);
            request.getRequestDispatcher("/WEB-INF/learner/update.jsp").forward(request, response);
        } finally {
            em.close();
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        EntityManager em = emf.createEntityManager();
        HttpSession session = request.getSession();

        String firstname = request.getParameter("firstname");
        String lastname = request.getParameter("lastname");
        String email = request.getParameter("email");

        Map<String, String> errors = new HashMap<>();

        try {
            em.getTransaction().begin();
            Learner apprenant = em.find(Learner.class, id);
            if (apprenant == null) {
                session.setAttribute("flashMessage", "Apprenant non trouvé.");
                session.setAttribute("flashType", "error");
                request.getRequestDispatcher("/WEB-INF/learner/update.jsp").forward(request, response);
                return;
            }

            apprenant.setFirstname(firstname);
            apprenant.setLastname(lastname);
            apprenant.setEmail(email);

            ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
            Validator validator = factory.getValidator();
            Set<ConstraintViolation<Learner>> violations = validator.validate(apprenant);

            if (!violations.isEmpty()) {
                for (ConstraintViolation<Learner> violation : violations) {
                    errors.put(violation.getPropertyPath().toString(), violation.getMessage());
                }
            }

            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.getRequestDispatcher("/WEB-INF/learner/update.jsp").forward(request, response);
                if (em.getTransaction().isActive()) {
                    em.getTransaction().rollback();
                }
                return;
            }

            em.getTransaction().commit();
            session.setAttribute("flashMessage", "L'apprenant a été mis à jour avec succès !");
            session.setAttribute("flashType", "success");
            response.sendRedirect(request.getContextPath() + Routes.LEARNER_LIST);
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }

            session.setAttribute("flashMessage", "Une erreur s'est produite lors de la mise à jour de l'apprenant.");
            session.setAttribute("flashType", "error");
            request.getRequestDispatcher("/WEB-INF/learner/update.jsp").forward(request, response);
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

}

