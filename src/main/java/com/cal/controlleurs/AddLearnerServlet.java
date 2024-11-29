package com.cal.controlleurs;

import com.cal.Routes;
import com.cal.models.Learner;
import jakarta.persistence.*;
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
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

@WebServlet(name = "apprenant.create", urlPatterns = {Routes.LEARNER_CREATE})
public class AddLearnerServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = (EntityManagerFactory) getServletContext().getAttribute("EntityManagerFactory");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/learner/create.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        String firstname = request.getParameter("firstname");
        String lastname = request.getParameter("lastname");
        String email = request.getParameter("email");

        Map<String, String> errors = new HashMap<>();

        Learner apprenant = new Learner();
        apprenant.setFirstname(firstname);
        apprenant.setLastname(lastname);
        apprenant.setEmail(email);
        apprenant.setCreatedAt(new Date());

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
            request.getRequestDispatcher("/WEB-INF/learner/create.jsp").forward(request, response);
            return;
        }

        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();
            em.persist(apprenant);
            transaction.commit();

            session.setAttribute("flashMessage", "L'apprenant a été ajouté avec succès !");
            session.setAttribute("flashType", "success");
        }

        catch (PersistenceException e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }

            Throwable cause = e.getCause();
            while (cause != null && !(cause instanceof SQLIntegrityConstraintViolationException)) {
                cause = cause.getCause();
            }

            if (cause != null) {
                errors.put("email", "L'email est déjà utilisé");
                System.out.println("L'email est déjà utilisé: " + cause.getMessage());
                request.setAttribute("errors", errors);
                request.getRequestDispatcher("/WEB-INF/learner/create.jsp").forward(request, response);
            } else {
                session.setAttribute("flashMessage", "Une erreur s'est produite lors de l'ajout de l'apprenant.");
                session.setAttribute("flashType", "error");
            }
            e.printStackTrace();
            return;
        } finally {
            em.close();
        }

        response.sendRedirect(request.getContextPath() + Routes.LEARNER_LIST);
    }

}
