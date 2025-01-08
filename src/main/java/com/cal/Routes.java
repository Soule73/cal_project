package com.cal;

public class Routes {

    // Accées public
    public static final String LOGIN = "/login";
    public static final String LOGOUT = "/logout";

    //accées admin
    public static final String LEARNER_LIST = "/learners";
    public static final String LEARNER_FORM = "/learner/form";
    public static final String LEARNER_SHOW = "/learners/show";

    public static final String LANG_LIST = "/languages";
    public static final String LANG_FORM = "/language/form";
    public static final String LANG_SHOW = "/languages/show";
    public static final String LANG_COURSE = "/language/course";

    public static final String ROOM_LIST = "/rooms";
    public static final String ROOM_FORM = "/rooms/form";

    public static final String COURSE_FORM = "/course/form";

    public static final String SUBCRIPTION_LIST = "/subcriptions";
    public static final String SUBCRIPTION_FORM = "/subcriptions/form";

    //Accéess à l'appreant et admin
    public static final String LEARN_SUBCRIPTIONS = "/learners/subcriptions";

    //Accées à l'apprenant
    public static final String CURRENT_LEARNER = "/learner";

    //Accées pour tout le monde si connecté
    public static final String MESSAGE = "/message";
    public static final String CHAT = "/chat";
    public static final String WS_URL = "ws://localhost:";
    public static final String GROUP_USER_SEARCH = "/group-user-search";
    public static final String PRIVATE_USER_SEARCH = "/user-search";


}
