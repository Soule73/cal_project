package com.cal.utils;

import com.cal.models.Learner;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;
import org.json.JSONObject;

import java.io.IOException;
import java.util.Map;
import java.util.Set;

public class ValidationUtils {
    public static boolean validateLearner(HttpServletResponse response, Map<String, String> errors, Learner learner) throws IOException {
        ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
        Validator validator = factory.getValidator();
        Set<ConstraintViolation<Learner>> violations = validator.validate(learner);

        if (!violations.isEmpty()) {
            for (ConstraintViolation<Learner> violation : violations) {
                errors.put(violation.getPropertyPath().toString(), violation.getMessage());
            }
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(new JSONObject(Map.of("errors", errors)).toString());
            return true;
        }
        return false;
    }
}
