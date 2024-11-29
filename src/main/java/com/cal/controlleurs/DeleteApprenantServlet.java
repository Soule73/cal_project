package com.cal.controlleurs;


import com.cal.Routes;
import com.cal.models.Learner;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;


@WebServlet(name = "apprenant.delete", urlPatterns = {Routes.LEARNER_DELETE})
public class DeleteApprenantServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = (EntityManagerFactory) getServletContext().getAttribute("EntityManagerFactory");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        EntityManager em = emf.createEntityManager();
        HttpSession session = request.getSession();


        try {
            em.getTransaction().begin();
            Learner apprenant = em.find(Learner.class, id);
            if (apprenant != null) {
                em.remove(apprenant);
            }
            em.getTransaction().commit();

            session.setAttribute("flashMessage", "L'apprenant a été supprimé avec succès !");
            session.setAttribute("flashType", "success");
        }
        catch (Exception e) {
            e.printStackTrace();
            em.getTransaction().rollback();
            session.setAttribute("flashMessage", "Une erreur s'est produite lors de suppression !");
            session.setAttribute("flashType", "error");
        }
        finally {
            em.close();
        }

        response.sendRedirect(request.getContextPath() + Routes.LEARNER_LIST);
    }
}

