STDOUT.sync = true # DO NOT REMOVE
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.


# game loop
boosted = false
cp = []
id = []
temp = 0
prev = 0
loop do
    # next_checkpoint_x: x position of the next check point
    # next_checkpoint_y: y position of the next check point
    # next_checkpoint_dist: distance to the next checkpoint
    # next_checkpoint_angle: angle between your pod orientation and the direction of the next checkpoint
    x, y, next_checkpoint_x, next_checkpoint_y, next_checkpoint_dist, next_checkpoint_angle = gets.split(" ").collect {|x| x.to_i}
    opponent_x, opponent_y = gets.split(" ").collect {|x| x.to_i}

    if !cp.include? [next_checkpoint_x, next_checkpoint_y]
       cp.push [next_checkpoint_x, next_checkpoint_y]
    end

    if cp.length == 4
        for i in 0..cp.length - 1
            for j in 0..cp.length - 1
                x = cp[j][0] - cp[i][0]
                y = cp[j][1] - cp[i][1]

                if Math.sqrt((x**2 - y**2).abs).to_i > temp
                    temp = Math.sqrt((x**2 - y**2).abs).to_i
                    id = cp[j]
                end
            end
        end
    end

    # Write an action using puts
    # To debug: STDERR.puts "Debug messages..."

    STDERR.puts [x, y].to_s

    if next_checkpoint_angle > 90 || next_checkpoint_angle < -90
        thrust = 0
    elsif next_checkpoint_angle < 90 && next_checkpoint_angle > 10  && next_checkpoint_angle > -10  && next_checkpoint_angle < -1
        thrust = (1000/next_checkpoint_angle.abs).ceil
    elsif !boosted && id[0] == next_checkpoint_x && id[1] == next_checkpoint_y && next_checkpoint_angle < 5 && next_checkpoint_angle > -5
        thrust = 'BOOST'
        boosted = true
    else
        thrust = 100
    end

    if thrust != 'BOOST'
        prev = thrust
    end

    dis = 0
    dis = Math.sqrt(((next_checkpoint_x - x)**2 + (next_checkpoint_y - y)**2).abs)

    STDERR.puts opponent_x

    # You have to output the target position
    # followed by the power (0 <= thrust <= 100)
    # i.e.: "x y thrust"
    printf("%d %d %s\n",next_checkpoint_x, next_checkpoint_y, thrust)
end
