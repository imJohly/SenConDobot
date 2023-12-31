myRobot = Dobot;
%myRobot.model.base = transl([0.1,0.1,0.1]);
myRobot.model.animate(zeros(1,5));
hold on
%%
q1 = myRobot.model.getpos();

target = transl(0,0.2,0.2);

plot3(target(1,4),target(2,4),target(3,4),'*r')

%%

q2 = myRobot.model.ikcon(target);

myRobot.model.animate(q2);


xBase = 0
yBase = 0
zBase = 0

baseTr = trans(xBase, yBase, zBase)

q1Test = atan(yTarget/xTarget)
q2Test
q3Test
q4Test = pi - q3Test - q2Test;
q5Test = 0 