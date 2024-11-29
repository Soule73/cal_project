package com.cal.controlleurs;


import com.cal.models.Learner;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

import static com.cal.Routes.LEARNER_LIST;

@WebServlet({LEARNER_LIST})
public class LearnerListServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = (EntityManagerFactory) getServletContext().getAttribute("EntityManagerFactory");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        List<Learner> learners = em.createQuery("SELECT a FROM Learner a", Learner.class).getResultList();
       request.setAttribute("apprenants", learners);
        request.getRequestDispatcher("WEB-INF/learner/list.jsp")
               .forward(request, response);
        em.close();
    }
}

