local RunService = game:GetService("RunService");

local ESP_Utils = {};

function ESP_Utils.newQuad(color)
    local quad = Drawing.new("Quad");
    quad.Visible = false;
    quad.PointA = Vector2.new(0, 0);
    quad.PointB = Vector2.new(0, 0);
    quad.PointC = Vector2.new(0, 0);
    quad.PointD = Vector2.new(0, 0);
    quad.Color = color;
    quad.Filled = true;
    quad.Thickness = 1;
    quad.Transparency = 0.25;
    return quad;
end;

function ESP_Utils.Colorize(color, lib)
    for i, v in pairs(lib) do
        v.Color = color;
    end;
end;

function ESP_Utils.Box3D(object, destroyConnection)
    local Camera = workspace.CurrentCamera;
    local Part = object;

    local quads = {
        quad1 = ESP_Utils.newQuad(Color3.fromRGB(255, 0, 0)),
        quad2 = ESP_Utils.newQuad(Color3.fromRGB(255, 0, 0)),
        quad3 = ESP_Utils.newQuad(Color3.fromRGB(255, 0, 0)),
        quad4 = ESP_Utils.newQuad(Color3.fromRGB(255, 0, 0)),
        quad5 = ESP_Utils.newQuad(Color3.fromRGB(255, 0, 0)),
        quad6 = ESP_Utils.newQuad(Color3.fromRGB(255, 0, 0)),
    };

    local function Updater()

        local connection;
        connection = RunService.RenderStepped:Connect(function(Deltatime: number)
            if object == nil then
                return;
            end;

            local partpos, onScreen = Camera:WorldToViewportPoint(Part.Position);

            if onScreen then
                for _,quad in quads do
                    quad.Visible = true
                end

                local size = Vector3.new(Part.Size.X / 2, Part.Size.Y / 2, Part.Size.Z / 2);

                local Top1 =
                    Camera:WorldToViewportPoint((Part.CFrame * CFrame.new(-size.X, size.Y, -size.Z)).p);
                local Top2 =
                    Camera:WorldToViewportPoint((Part.CFrame * CFrame.new(-size.X, size.Y, size.Z)).p);
                local Top3 =
                    Camera:WorldToViewportPoint((Part.CFrame * CFrame.new(size.X, size.Y, size.Z)).p);
                local Top4 =
                    Camera:WorldToViewportPoint((Part.CFrame * CFrame.new(size.X, size.Y, -size.Z)).p);

                local Bottom1 =
                    Camera:WorldToViewportPoint((Part.CFrame * CFrame.new(-size.X, -size.Y, -size.Z)).p);
                local Bottom2 =
                    Camera:WorldToViewportPoint((Part.CFrame * CFrame.new(-size.X, -size.Y, size.Z)).p);
                local Bottom3 =
                    Camera:WorldToViewportPoint((Part.CFrame * CFrame.new(size.X, -size.Y, size.Z)).p);
                local Bottom4 =
                    Camera:WorldToViewportPoint((Part.CFrame * CFrame.new(size.X, -size.Y, -size.Z)).p);

                quads.quad1.PointA = Vector2.new(Top1.X, Top1.Y);
                quads.quad1.PointB = Vector2.new(Top2.X, Top2.Y);
                quads.quad1.PointC = Vector2.new(Top3.X, Top3.Y);
                quads.quad1.PointD = Vector2.new(Top4.X, Top4.Y);

                --//Bottom:
                quads.quad2.PointA = Vector2.new(Bottom1.X, Bottom1.Y);
                quads.quad2.PointB = Vector2.new(Bottom2.X, Bottom2.Y);
                quads.quad2.PointC = Vector2.new(Bottom3.X, Bottom3.Y);
                quads.quad2.PointD = Vector2.new(Bottom4.X, Bottom4.Y);

                --//Sides:
                quads.quad3.PointA = Vector2.new(Top1.X, Top1.Y);
                quads.quad3.PointB = Vector2.new(Top2.X, Top2.Y);
                quads.quad3.PointC = Vector2.new(Bottom2.X, Bottom2.Y);
                quads.quad3.PointD = Vector2.new(Bottom1.X, Bottom1.Y);

                quads.quad4.PointA = Vector2.new(Top2.X, Top2.Y);
                quads.quad4.PointB = Vector2.new(Top3.X, Top3.Y);
                quads.quad4.PointC = Vector2.new(Bottom3.X, Bottom3.Y);
                quads.quad4.PointD = Vector2.new(Bottom2.X, Bottom2.Y);

                quads.quad5.PointA = Vector2.new(Top3.X, Top3.Y);
                quads.quad5.PointB = Vector2.new(Top4.X, Top4.Y);
                quads.quad5.PointC = Vector2.new(Bottom4.X, Bottom4.Y);
                quads.quad5.PointD = Vector2.new(Bottom3.X, Bottom3.Y);

                quads.quad6.PointA = Vector2.new(Top4.X, Top4.Y);
                quads.quad6.PointB = Vector2.new(Top1.X, Top1.Y);
                quads.quad6.PointC = Vector2.new(Bottom1.X, Bottom1.Y);
                quads.quad6.PointD = Vector2.new(Bottom4.X, Bottom4.Y);

            else
                for _,quad in quads do
                    quad.Visible = false
                end
            end;

        end);

        local connection2 = destroyConnection:Once(function()
            for _,quad in quads do quad:Destroy() end
            connection:Disconnect()
        end)

        return {
            Destroy = function()
                for _,quad in quads do
                    quad:Destroy()
                    connection:Disconnect()
                    connection2:Disconnect()
                end
            end
        }
    end;


    return Updater()
end;

return ESP_Utils;
