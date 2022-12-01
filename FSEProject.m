global key;
InitKeyboard();
brick.SetColorMode(1, 2);

leftWheel = 48; % A Motor
rightWheel = 50; % D Motor
currentDist = brick.UltrasonicDist(3);
navigating = true;
turned = false;
pickedUp = false;
completed = false;
colorUpdate = false;

% Motor A/D     - Wheel Motors
% Motor C       - Lift Motor
% Sensor Port 1 - Color Sensor

       
% Constant running loop

while 1
   pause(0.1);
   color = brick.ColorCode(1);
   % Stops the code if the passenger has been dropped off
   if color == 4 && completed == true
       brick.MoveMotor('A', 0);
       brick.MoveMotor('D', 0);
       break;
   end
   % Code that allows navigation to continue while the car is technically
   % on another color if necessary
   if colorUpdate
       color = 4;
       colorUpdate = false;
   end
   switch color
       case 4 % Yellow Detection // Start Drive
            while navigating
                % Checks during the navigation loop for other colors
                if brick.ColorCode(1) == 5 || (brick.ColorCode(1) == 2 && pickedUp == false) || (brick.ColorCode(1) == 3 && completed == false)
                    navigating = false;
                    break;
                end
                % If yellow is reached again after dropoff is completed,
                % stop the motors and break the loop.
                if brick.ColorCode(1) == 4 && completed == true
                    brick.StopMotor('A');
                    brick.StopMotor('D');
                    
                    break;
                end
                % Sets dist to the distance from the left to the wall
                dist = brick.UltrasonicDist(3);
                display(dist)
                
                % If the brick activates the touch sensors, back up and do
                % a 90 degree turn. 
                if brick.TouchPressed(4) == 1 || brick.TouchPressed(2) == 1
                    pause(0.5);
                    % Back up slightly to make room
                    brick.MoveMotor('A', -50);
                    brick.MoveMotor('D', -50);
                    pause(1);
                    % Do a 90 and turn around
                    brick.MoveMotor('A', 25);
                    brick.MoveMotor('D', -25);
                    pause(.95);
                  
                % If the wall is more than 50 units away
                elseif dist > 50 && turned == false
                    
                    turned = true;
                    pause(0.5);
                    % Turns the robot to the right
                    brick.MoveMotor('A', -25);
                    brick.MoveMotor('D', 25);
                        % This number needs to be tuned
                    pause(1.35);
                    % Moves forward to prevent double turning
                    brick.MoveMotor('A', 50);
                    brick.MoveMotor('D', 50);
                    % Checks for red during this move forward
                    if brick.ColorCode(1) == 5
                        break;
                    end
                    pause(0.25);
                    if brick.ColorCode(1) == 5
                        break;
                    end
                    pause(0.25);
                    if brick.ColorCode(1) == 5
                        break;
                    end
                    pause(0.25);
                    if brick.ColorCode(1) == 5
                        break;
                    end
                    pause(0.25);
                    if brick.ColorCode(1) == 5
                        break;
                    end
                    pause(0.25);
                    if brick.ColorCode(1) == 5
                        break;
                    end
                    pause(0.25);
                    if brick.ColorCode(1) == 5
                        break;
                    end
                    pause(0.25);
                    if brick.ColorCode(1) == 5
                        break;
                    end
                    pause(0.25);
                else
                    % If neither sensor is activated, move both motors
                    % forward
                    brick.MoveMotor('A', leftWheel);
                    brick.MoveMotor('D', rightWheel);
                    turned = false;
                end
               
    
            end
       case 5 % Red Detection // Stop Drive

           % Stop the car for 4 seconds, then restart motion
           brick.MoveMotor('A', 0);
           brick.MoveMotor('D', 0);
           pause(4);
           brick.MoveMotor('A', leftWheel);
           brick.MoveMotor('D', rightWheel);
           pause(1);
           colorUpdate = true;
           navigating = true;
       case 3 % Green Detection // Manual Mode Dropoff
           % If the car has not been picked up yet, restart navigation
           if pickedUp == false  
               colorUpdate = true;
               continue;
           end
           % Stop the car and enable keyboard control
           brick.MoveMotor('A', 0);
           brick.MoveMotor('D', 0);
           pause(0.5);
           brick.MoveMotor('C', 0);
           while 1
               pause(0.1);
               switch key
                   case 'uparrow'
                       brick.MoveMotor('A', 50);
                       brick.MoveMotor('D', 50);
                   case 'downarrow'
                       brick.MoveMotor('A', -50);
                       brick.MoveMotor('D', -50);
                   case 'leftarrow'
                       brick.MoveMotor('A', -50);
                       brick.MoveMotor('D', 50);
                   case 'rightarrow'
                       brick.MoveMotor('A', 50);
                       brick.MoveMotor('D', -50);
                   case 0
                       brick.MoveMotor('A', 0);
                       brick.MoveMotor('D', 0);
                       brick.MoveMotor('C', 0);
                   case 'q'
                       brick.MoveMotor('C', 15);

                   case 'e'
                       brick.MoveMotor('C', -15);
                       
                   case 'escape'
                       completed = true; 
                       pickedUp = false;
                       colorUpdate = true;
                       break;
               end
           end
          
           brick.MoveMotor('C', 0);
       case 2 % Blue Detection // Pickup
           % If the car is picked up or the entire process is completed, 
           % continue with navigation
           if pickedUp == true || completed == true
               colorUpdate = true;
               continue;
           else
               % Stop the movement motors, drop the arm
               brick.MoveMotor('A', 0);
               brick.MoveMotor('D', 0);
               brick.MoveMotor('C', -15);
               pause(0.5);
               brick.MoveMotor('C', 0);
               while pickedUp == false
                   pause(0.1);
                   % Start manual control
                   switch key
                       case 'uparrow'
                           brick.MoveMotor('A', 50);
                           brick.MoveMotor('D', 50);
                       case 'downarrow'
                           brick.MoveMotor('A', -50);
                           brick.MoveMotor('D', -50);
                       case 'leftarrow'
                           brick.MoveMotor('A', -35);
                           brick.MoveMotor('D', 35);
                       case 'rightarrow'
                           brick.MoveMotor('A', 35);
                           brick.MoveMotor('D', -35);
                       case 0
                           brick.MoveMotor('A', 0);
                           brick.MoveMotor('D', 0);
                           brick.MoveMotor('C', 0);
                       case 'q'
                           brick.MoveMotor('C', 15);

                       case 'e'
                           brick.MoveMotor('C', -15);
                        
                       case 'escape'
                           % Sets pickedUp to true after the car is picked up
                           pickedUp = true;
                           colorUpdate = true;
                           break;
                   end
               end
           end
   end
end      
CloseKeyboard();
