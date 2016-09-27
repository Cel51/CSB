STDOUT.sync = true # DO NOT REMOVE
# Auto-generated code below aims at helping you parse
# the standard input according to the problem statement.


# game loop

has_boost = true
best_dist = 0
tbest_dist = 0

checkpoints = []
first_lap = true

prev = 0

def distance(a, b)
   return Math.sqrt((a[0] - b[0])**2 + (a[1] - b[1])**2)
end

loop do
    x, y, next_checkpoint_x, next_checkpoint_y, next_checkpoint_dist, next_checkpoint_angle = gets.split(" ").collect {|x| x.to_i}
    opponent_x, opponent_y = gets.split(" ").collect {|x| x.to_i}

    if !checkpoints.include? [next_checkpoint_x, next_checkpoint_y]
        checkpoints.push [next_checkpoint_x, next_checkpoint_y]
    elsif first_lap && checkpoints.length > 1 && checkpoints[0] == [next_checkpoint_x, next_checkpoint_y]
        first_lap = false
        for i in 0..checkpoints.length - 1
            for j in 0..checkpoints.length - 1
                if distance(checkpoints[i], checkpoints[j]) > tbest_dist
                    tbest_dist = distance(checkpoints[i], checkpoints[j])
                    best_dist = checkpoints[j]
                end
            end
        end
    end

    STDERR.puts checkpoints.to_s
    STDERR.puts best_dist.to_s
    STDERR.puts has_boost

    if next_checkpoint_angle.abs > 90
        thrust = 0
    elsif next_checkpoint_angle.abs < 90 && next_checkpoint_angle.abs > 10
        thrust = (1000/next_checkpoint_angle.abs).ceil
    elsif has_boost && best_dist == [next_checkpoint_x, next_checkpoint_y] && next_checkpoint_angle.abs < 5
        thrust = 'BOOST'
        has_boost = false
    else
        thrust = 100
    end

    if thrust != 'BOOST'
        prev = thrust
    end

    #dis = 0
    #dis = Math.sqrt(((next_checkpoint_x - x)**2 + (next_checkpoint_y - y)**2).abs)

    # You have to output the target position
    # followed by the power (0 <= thrust <= 100)
    # i.e.: "x y thrust"
    printf("%d %d %s\n",next_checkpoint_x, next_checkpoint_y, thrust)
end
