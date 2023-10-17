--1. Saca el nombre y apellido de todos los usuarios que sean profesores.
SELECT name, first_surname
FROM User
WHERE role = "teacher";
--2. Saca el nombre y apellido de los estudiantes junto con el nombre de su escuela.
SELECT U.name, U.first_surname, S.name AS school_name
FROM User U INNER JOIN School_user_rel SUR 
ON U.id = SUR.id_user
INNER JOIN School S 
ON S.id = SUR.id_school
WHERE U.role = "student";
/*3. Nombre y apellido de los estudiantes junto con los nombres y el curso (campo course de la tabla
Subject) de las asignaturas que tenga matriculadas este año.*/
SELECT U.name, U.first_surname, S.name AS subject, S.course AS course
FROM User U INNER JOIN Enrolled_course EC
ON U.id = EC.id_student
INNER JOIN Enrolled_subject_rel ESR
ON EC.id = ESR.id_enrolled_course
INNER JOIN Subject S
ON ESR.id_subject = S.id
WHERE U.role = "student" 
	AND YEAR(NOW()) = YEAR(EC.created_at);
--4. Número de alumnos por escuela (de la escuela sacar el nombre).
SELECT S.name AS School, COUNT(U.id) AS num_students
FROM School S INNER JOIN School_user_rel SUR
ON S.id = SUR.id_school
INNER JOIN User U
ON SUR.id_user = U.id
WHERE role = "student"
GROUP BY S. name
--5. Nombre de asignatura y nota media histórica de todas las asignaturas, aunque no tengan notas registradas.
SELECT S.name, AVG(G.grade) AS avg_grade
FROM Subject S LEFT JOIN Grade G
ON S.id = G.id_subject
GROUP BY S.name;
--6. Nombre y apellidos del alumno con la nota más alta registrada. En caso de empate sacar todos los nombres.
SELECT U.name, U.first_surname, G.grade
FROM User U INNER JOIN Grade G
ON U.id = G.id_student
WHERE G.grade = (SELECT MAX(grade)
                FROM Grade)
--7. Tiempo total de asistencia por alumno(id), solo de aquellos que tenga registrado alguna asistencia en el año 2023.
SELECT id_user, SUM(time) AS total_time
FROM Attendance 
WHERE id_user IN (
    SELECT DISTINCT id_user
    FROM Attendance
    WHERE YEAR(date) = 2023
)
GROUP BY id_user