function myApp3()
    faultAnalysisApp();
end

function faultAnalysisApp()
    % Create Main Window
    faultFig = uifigure('Name', 'Fault Analysis', 'Position', [150, 150, 800, 600], ...
        'Color', [0.05, 0.05, 0.05]); % Blackish background

    % Add Background Image
    bgImage = uiimage(faultFig);
    bgImage.Position = [0, 0, 800, 600];
    bgImage.ImageSource = "C:\\Users\\Manjeet Singh\\OneDrive\\Desktop\\appMLB\\window2backgroundphoto.png";

    % Title Label
    titleLabel = uilabel(faultFig, 'Text', '    Transmission Line Fault Analysis', ...
        'FontSize', 24, 'FontWeight', 'bold', 'FontColor', 'white', ...
        'FontName', 'Cambria', 'Position', [200, 520, 400, 30]);

    % Balanced Fault Button
    balancedButton = uibutton(faultFig, 'Text', "Balanced Fault Analysis", ...
        'FontSize', 16, 'FontWeight', 'bold', 'FontName', 'Cambria', ...
        'Position', [275, 350, 250, 50], 'BackgroundColor', [0.2, 0.6, 0.8], ...
        'FontColor', 'white');

    % Unbalanced Fault Button
    unbalancedButton = uibutton(faultFig, 'Text', "Unbalanced Fault Analysis", ...
        'FontSize', 16, 'FontWeight', 'bold', 'FontName', 'Cambria', ...
        'Position', [275, 250, 250, 50], 'BackgroundColor', [0.8, 0.4, 0.2], ...
        'FontColor', 'white');
    
    % Theory Button
    theoryButton = uibutton(faultFig, 'Text', "Learn About Fault Analysis", ...
        'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Cambria', ...
        'Position', [275, 150, 250, 40], 'BackgroundColor', [0.4, 0.2, 0.6], ...
        'FontColor', 'white');

    % Button Functions
    balancedButton.ButtonPushedFcn = @(~, ~) switchToBalancedAnalysis(faultFig, titleLabel, balancedButton, unbalancedButton, bgImage, theoryButton);
    unbalancedButton.ButtonPushedFcn = @(~, ~) switchToUnbalancedSelection(faultFig, titleLabel, balancedButton, unbalancedButton, bgImage, theoryButton);
    theoryButton.ButtonPushedFcn = @(~, ~) showFaultTheory(faultFig, titleLabel, balancedButton, unbalancedButton, bgImage, theoryButton);
end

function switchToBalancedAnalysis(fig, titleLabel, balancedButton, unbalancedButton, bgImage, theoryButton)
    % Remove Buttons and Background Image
    delete(balancedButton);
    delete(unbalancedButton);
    delete(bgImage);
    delete(theoryButton);
    
    % Update Title
    titleLabel.Text = 'Balanced Fault Analysis';

    % Create Panel for Inputs
    panel = uipanel(fig, 'Position', [200, 120, 400, 380], ...
        'BackgroundColor', [0.1, 0.1, 0.1]); % Dark Panel

    % Input Fields
    vField = createInputField(panel, 'System Voltage (V) (kV):', 340);
    rsField = createInputField(panel, 'Source Resistance (Rs) (Ω):', 300);
    xsField = createInputField(panel, 'Source Reactance (Xs) (Ω):', 260);
    rlField = createInputField(panel, 'Line Resistance (Rl) (Ω):', 220);
    xlField = createInputField(panel, 'Line Reactance (Xl) (Ω):', 180);
    rfField = createInputField(panel, 'Fault Resistance (Rf) (Ω):', 140);

    % Submit Button
    submitButton = uibutton(panel, 'Text', 'Submit', ...
        'FontSize', 16, 'FontWeight', 'bold', 'FontName', 'Cambria', ...
        'Position', [140, 50, 120, 40], 'BackgroundColor', [0.2, 0.8, 0.2], ...
        'FontColor', 'white');

    % Back Button
    backButton = uibutton(panel, 'Text', 'Back', ...
        'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Cambria', ...
        'Position', [140, 10, 120, 30], 'BackgroundColor', [0.8, 0.2, 0.2], ...
        'FontColor', 'white');

    % Theory Button
    miniTheoryButton = uibutton(panel, 'Text', 'Theory', ...
        'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Cambria', ...
        'Position', [20, 10, 80, 30], 'BackgroundColor', [0.4, 0.2, 0.6], ...
        'FontColor', 'white');

    % Button Functions
    submitButton.ButtonPushedFcn = @(~, ~) computeBalancedFault(fig, vField, rsField, xsField, rlField, xlField, rfField);
    backButton.ButtonPushedFcn = @(~, ~) faultAnalysisApp();
    miniTheoryButton.ButtonPushedFcn = @(~, ~) showBalancedFaultTheory(fig);
end

function switchToUnbalancedSelection(fig, titleLabel, balancedButton, unbalancedButton, bgImage, theoryButton)
    % Remove Buttons and Background Image
    if ~isempty(balancedButton) && isvalid(balancedButton)
        delete(balancedButton);
    end
    if ~isempty(unbalancedButton) && isvalid(unbalancedButton)
        delete(unbalancedButton);
    end
    if ~isempty(bgImage) && isvalid(bgImage)
        delete(bgImage);
    end
    if ~isempty(theoryButton) && isvalid(theoryButton)
        delete(theoryButton);
    end

    % Update Title
    titleLabel.Text = 'Unbalanced Fault Analysis';

    % Create Panel for Selection
    panel = uipanel(fig, 'Position', [200, 120, 400, 380], ...
        'BackgroundColor', [0.1, 0.1, 0.1]); % Dark Panel

    % Fault Type Label
    faultTypeLabel = uilabel(panel, 'Text', 'Select Fault Type:', 'FontSize', 18, ...
        'FontWeight', 'bold', 'FontColor', 'white', 'FontName', 'Cambria', ...
        'Position', [110, 320, 180, 30]);

    % Fault Type Buttons
    lgButton = uibutton(panel, 'Text', 'Line-to-Ground (LG)', ...
        'FontSize', 16, 'FontWeight', 'bold', 'FontName', 'Cambria', ...
        'Position', [75, 250, 250, 50], 'BackgroundColor', [0.6, 0.4, 0.8], ...
        'FontColor', 'white');

    llButton = uibutton(panel, 'Text', 'Line-to-Line (LL)', ...
        'FontSize', 16, 'FontWeight', 'bold', 'FontName', 'Cambria', ...
        'Position', [75, 180, 250, 50], 'BackgroundColor', [0.4, 0.6, 0.8], ...
        'FontColor', 'white');

    llgButton = uibutton(panel, 'Text', 'Double Line-to-Ground (LLG)', ...
        'FontSize', 16, 'FontWeight', 'bold', 'FontName', 'Cambria', ...
        'Position', [75, 110, 250, 50], 'BackgroundColor', [0.8, 0.6, 0.4], ...
        'FontColor', 'white');

    % Back Button
    backButton = uibutton(panel, 'Text', 'Back', ...
        'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Cambria', ...
        'Position', [140, 30, 120, 30], 'BackgroundColor', [0.8, 0.2, 0.2], ...
        'FontColor', 'white');

    % Theory Button
    miniTheoryButton = uibutton(panel, 'Text', 'Theory', ...
        'FontSize', 12, 'FontWeight', 'bold', 'FontName', 'Cambria', ...
        'Position', [20, 30, 80, 30], 'BackgroundColor', [0.4, 0.2, 0.6], ...
        'FontColor', 'white');

    % Button Functions
    lgButton.ButtonPushedFcn = @(~, ~) switchToUnbalancedAnalysis(fig, 'LG', titleLabel);
    llButton.ButtonPushedFcn = @(~, ~) switchToUnbalancedAnalysis(fig, 'LL', titleLabel);
    llgButton.ButtonPushedFcn = @(~, ~) switchToUnbalancedAnalysis(fig, 'LLG', titleLabel);
    backButton.ButtonPushedFcn = @(~, ~) faultAnalysisApp();
    miniTheoryButton.ButtonPushedFcn = @(~, ~) showUnbalancedFaultTheory(fig);
end

function switchToUnbalancedAnalysis(fig, faultType, titleLabel)
    % Clear Figure
    clf(fig);
    fig.Color = [0.05, 0.05, 0.05];

    % Update Title based on fault type
    switch faultType
        case 'LG'
            faultTypeText = 'Line-to-Ground Fault Analysis';
        case 'LL'
            faultTypeText = 'Line-to-Line Fault Analysis';
        case 'LLG'
            faultTypeText = 'Double Line-to-Ground Fault Analysis';
    end

    % Set Title
    titleLabel = uilabel(fig, 'Text', faultTypeText, ...
        'FontSize', 24, 'FontWeight', 'bold', 'FontColor', 'white', ...
        'FontName', 'Cambria', 'Position', [200, 520, 400, 30]);

    % Create Panel for Inputs
    panel = uipanel(fig, 'Position', [200, 120, 400, 380], ...
        'BackgroundColor', [0.1, 0.1, 0.1]); % Dark Panel

    % Input Fields
    vField = createInputField(panel, 'System Voltage (V) (kV):', 340);
    z1rField = createInputField(panel, 'Positive Sequence R (Ω):', 300);
    z1xField = createInputField(panel, 'Positive Sequence X (Ω):', 260);
    z2rField = createInputField(panel, 'Negative Sequence R (Ω):', 220);
    z2xField = createInputField(panel, 'Negative Sequence X (Ω):', 180);
    z0rField = createInputField(panel, 'Zero Sequence R (Ω):', 140);
    z0xField = createInputField(panel, 'Zero Sequence X (Ω):', 100);
    rfField = createInputField(panel, 'Fault Resistance (Rf) (Ω):', 60);

    % Submit Button
    submitButton = uibutton(panel, 'Text', 'Submit', ...
        'FontSize', 16, 'FontWeight', 'bold', 'FontName', 'Cambria', ...
        'Position', [140, 20, 120, 40], 'BackgroundColor', [0.2, 0.8, 0.2], ...
        'FontColor', 'white');

    % Back Button
    backButton = uibutton(fig, 'Text', 'Back', ...
        'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Cambria', ...
        'Position', [340, 80, 120, 30], 'BackgroundColor', [0.8, 0.2, 0.2], ...
        'FontColor', 'white');
    
    % Theory Button
    theoryButton = uibutton(fig, 'Text', 'Theory', ...
        'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Cambria', ...
        'Position', [340, 120, 120, 30], 'BackgroundColor', [0.4, 0.2, 0.6], ...
        'FontColor', 'white');

    % Button Functions
    submitButton.ButtonPushedFcn = @(~, ~) computeUnbalancedFault(fig, faultType, vField, z1rField, z1xField, z2rField, z2xField, z0rField, z0xField, rfField);
    backButton.ButtonPushedFcn = @(~, ~) switchToUnbalancedSelection(fig, titleLabel, [], [], [], []);
    theoryButton.ButtonPushedFcn = @(~, ~) showSpecificFaultTheory(fig, faultType);
end

function field = createInputField(panel, labelText, yPos)
    % Create Label
    uilabel(panel, 'Text', labelText, 'FontSize', 14, ...
        'FontWeight', 'bold', 'FontColor', 'white', 'FontName', 'Cambria', ...
        'Position', [20, yPos, 200, 30]);

    % Create Input Box
    field = uieditfield(panel, 'numeric', 'Position', [270, yPos + 5, 100, 30]);
end

function computeBalancedFault(fig, vField, rsField, xsField, rlField, xlField, rfField)
    % Retrieve Input Values
    V = vField.Value * 1000; % Convert from kV to V
    Rs = rsField.Value;
    Xs = xsField.Value;
    Rl = rlField.Value;
    Xl = xlField.Value;
    Rf = rfField.Value;
    
    % Calculate Total Impedance
    Zs = complex(Rs, Xs);
    Zl = complex(Rl, Xl);
    Z_total = Zs + Zl + Rf;
    
    % Calculate Fault Current (If)
    If = abs(V / Z_total);
    
    % Calculate Fault Power (MW)
    S_fault = sqrt(3) * V * If / 1e6; % Convert to MW
    
    % Interpretation
    if If > 10000
        severity = 'EXTREMELY DANGEROUS';
        interpretation = 'Fault current is extremely high,may cause severe damage to equipment.Protection required';
        action = 'Check circuit breakers and protection relays. Consider system redesign to reduce fault levels.';
    elseif If > 5000
        severity = 'VERY HIGH';
        interpretation = 'This is a very high fault current that could damage equipment if not cleared quickly.';
        action = 'Ensure protection devices are properly rated and coordinated.';
    elseif If > 1000
        severity = 'MODERATE';
        interpretation = 'This is a moderate fault current that typical protection systems should handle.';
        action = 'Standard protection devices should operate effectively.';
    else
        severity = 'LOW';
        interpretation = 'This is a relatively low fault current that may not require immediate action.';
        action = 'Verify protection settings for sensitive operation.';
    end
    
    % Display Results
    displayResults(fig, 'Balanced Fault Analysis Results', If, S_fault, severity, interpretation, action);
end

function computeUnbalancedFault(fig, faultType, vField, z1rField, z1xField, z2rField, z2xField, z0rField, z0xField, rfField)
    % Retrieve Input Values
    V = vField.Value * 1000; % Convert from kV to V
    Z1 = complex(z1rField.Value, z1xField.Value);
    Z2 = complex(z2rField.Value, z2xField.Value);
    Z0 = complex(z0rField.Value, z0xField.Value);
    Rf = rfField.Value;
    
    % Calculate Fault Current (If) based on fault type
    switch faultType
        case 'LG' % Line-to-Ground
            If = abs(3 * V / (Z1 + Z2 + Z0 + 3*Rf));
            faultText = 'Line-to-Ground Fault';
        case 'LL' % Line-to-Line
            If = abs(sqrt(3) * V / (Z1 + Z2 + Rf));
            faultText = 'Line-to-Line Fault';
        case 'LLG' % Double Line-to-Ground
            If = abs(2 * V / (Z1 + (Z2 * (Z0 + 3*Rf)) / (Z2 + Z0 + 3*Rf)));
            faultText = 'Double Line-to-Ground Fault';
    end
    
    % Calculate Fault Power (MW)
    S_fault = sqrt(3) * V * If / 1e6; % Convert to MW
    
    % Interpretation based on fault type
    switch faultType
        case 'LG'
            if If > 10000
                severity = 'EXTREMELY DANGEROUS';
                interpretation = 'severe ground fault causing extensive damage to equipment';
                action = 'Do Immediate isolation,Check grounding system and protection relays.';
            elseif If > 5000
                severity = 'HIGH';
                interpretation = 'This significant ground fault requires fast protection operation.';
                action = 'Verify ground fault protection settings and coordination.';
            else
                severity = 'MODERATE';
                interpretation = 'This ground fault is within typical system handling capabilities.';
                action = 'Standard protection should operate effectively.';
            end
        case 'LL'
            if If > 8000
                severity = 'VERY HIGH';
                interpretation = 'LL fault could cause significant thermal & mechanical stress.';
                action = 'Ensure proper phase protection coordination.';
            elseif If > 3000
                severity = 'MODERATE';
                interpretation = 'This LL fault is manageable with proper protection.';
                action = 'Check phase protection device ratings.';
            else
                severity = 'LOW';
                interpretation = 'This line-to-line fault has limited impact.';
                action = 'Monitor protection system operation.';
            end
        case 'LLG'
            if If > 7000
                severity = 'SEVERE';
                interpretation = 'Fault could cause unbalanced system operation and equipment damage.';
                action = 'Immediate action required.Check all phase and ground protection.';
            elseif If > 3500
                severity = 'SIGNIFICANT';
                interpretation = 'Fault requires coordinated protection operation.';
                action = 'Verify protection coordination for multi-phase faults.';
            else
                severity = 'MODERATE';
                interpretation = 'Fault is within design limits.';
                action = 'Standard protection should handle this scenario.';
            end
    end
    
    % Display Results
    displayResults(fig, [faultText ' Analysis Results'], If, S_fault, severity, interpretation, action);
end

function displayResults(fig, titleText, If, S_fault, severity, interpretation, action)
    % Clear Figure
    clf(fig);
    fig.Color = [0.05, 0.05, 0.05];
    
    % Title Label
    titleLabel = uilabel(fig, 'Text', titleText, ...
        'FontSize', 24, 'FontWeight', 'bold', 'FontColor', 'white', ...
        'FontName', 'Cambria', 'Position', [200, 520, 400, 30]);
    
    % Results Panel
    resultsPanel = uipanel(fig, 'Position', [100, 50, 600, 500], ...
        'BackgroundColor', [0.1, 0.1, 0.1]);
    
    % Display Results
    uilabel(resultsPanel, 'Text', 'Analysis Results:', ...
        'FontSize', 18, 'FontWeight', 'bold', 'FontColor', 'white', 'FontName', 'Cambria', ...
        'Position', [230, 450, 200, 30]);
    
    uilabel(resultsPanel, 'Text', sprintf('Fault Current (If): %.2f A', If), ...
        'FontSize', 16, 'FontWeight', 'bold', 'FontColor', 'white', 'FontName', 'Cambria', ...
        'Position', [50, 400, 300, 30]);
    
    uilabel(resultsPanel, 'Text', sprintf('Fault Power: %.2f MW', S_fault), ...
        'FontSize', 16, 'FontWeight', 'bold', 'FontColor', 'white', 'FontName', 'Cambria', ...
        'Position', [50, 370, 300, 30]);
    
    % Severity Rating
    uilabel(resultsPanel, 'Text', sprintf('Severity: %s', severity), ...
        'FontSize', 16, 'FontWeight', 'bold', 'FontColor', [0.9, 0.3, 0.3], 'FontName', 'Cambria', ...
        'Position', [50, 340, 300, 30]);
    
    % Interpretation
    interpretationLabel = uilabel(resultsPanel, 'Text', ['Interpretation: ' interpretation], ...
        'FontSize', 14, 'FontColor', 'white', 'FontName', 'Cambria', ...
        'Position', [50, 280, 500, 60], 'WordWrap', 'on');
    
    % Recommended Action
    actionLabel = uilabel(resultsPanel, 'Text', ['Recommended Action: ' action], ...
        'FontSize', 14, 'FontColor', [0.3, 0.8, 0.3], 'FontName', 'Cambria', ...
        'Position', [50, 200, 500, 60], 'WordWrap', 'on');
    
    % Add visual representation of current
    gaugeMin = 0;
    gaugeMax = max(If * 1.5, 10000);
    gaugeSize = [100, 100];
    gaugePosition = [400, 370, gaugeSize];
    
    currentGauge = uigauge(resultsPanel, 'circular', 'Position', gaugePosition, ...
        'Limits', [gaugeMin, gaugeMax], 'Value', If, ...
        'FontColor', 'white', 'ScaleColors', [0 0 1; 0 1 0; 1 0 0]);
    
    uilabel(resultsPanel, 'Text', 'Current Magnitude', ...
        'FontSize', 12, 'FontColor', 'white', 'FontName', 'Cambria', ...
        'Position', [400, 350, 120, 20]);
    
    % Back Button
    backButton = uibutton(resultsPanel, 'Text', 'Back to Main', ...
        'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Cambria', ...
        'Position', [240, 50, 120, 40], 'BackgroundColor', [0.8, 0.2, 0.2], ...
        'FontColor', 'white');
    
    % Plot Button
    plotButton = uibutton(resultsPanel, 'Text', 'View (I vs t) Plot', ...
        'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Cambria', ...
        'Position', [240, 100, 120, 40], 'BackgroundColor', [0.2, 0.6, 0.8], ...
        'FontColor', 'white');
    
    % Button Functions
    backButton.ButtonPushedFcn = @(~, ~) faultAnalysisApp();
    plotButton.ButtonPushedFcn = @(~, ~) plotFaultResults(If);
end

function plotFaultResults(If)
    % Create a New Figure for Plotting
    plotFig = uifigure('Name', 'Fault Current Plot', 'Position', [200, 200, 600, 400], ...
        'Color', [0.05, 0.05, 0.05]);

    % Create Axes for Plotting
    plotAxes = uiaxes(plotFig, 'Position', [50, 50, 500, 300]);
    plotAxes.XLabel.String = 'Time (s)';
    plotAxes.YLabel.String = 'Fault Current (A)';
    plotAxes.Title.String = 'Fault Current Over Time';
    plotAxes.Color = [0.1, 0.1, 0.1];
    plotAxes.XColor = 'white';
    plotAxes.YColor = 'white';
    plotAxes.Title.Color = 'white';
    plotAxes.GridColor = 'white';

    % Simulate Fault Current Over Time
    time = linspace(0, 0.1, 100); % Time vector (0 to 0.1 seconds)
    faultCurrent = If * sin(2 * pi * 50 * time); % Simulate AC fault current (50 Hz)

    % Plot Fault Current
    plot(plotAxes, time, faultCurrent, 'r', 'LineWidth', 2);
    
    % Add annotation about fault clearing
    if If > 5000
        annotationText = sprintf('High fault current!\nTypical circuit breakers clear in 3-5 cycles (0.06-0.1s)');
        text(plotAxes, 0.05, If*0.8, annotationText, ...
            'Color', 'yellow', 'FontSize', 10, 'FontWeight', 'bold');
    end
end

function showFaultTheory(fig, titleLabel, balancedButton, unbalancedButton, bgImage, theoryButton)
    % Clear existing components
    delete(balancedButton);
    delete(unbalancedButton);
    delete(bgImage);
    delete(theoryButton);
    
    % Update title
    titleLabel.Text = 'Fault Analysis Theory';
    
    % Create scrollable panel
    panel = uipanel(fig, 'Position', [50, 50, 700, 500], ...
        'BackgroundColor', [0.1, 0.1, 0.1], 'Scrollable', 'on');
    
    % Theory content
    content = {
        'Fault Analysis Theory', 24, [240, 450, 300, 40];
        'What are Power System Faults?', 20, [50, 400, 300, 30];
        'Abnormal condition caused by failures in insulation or equipment resulting into high currents', 14, [50, 350, 600, 60];
        'Types of Faults:', 20, [50, 300, 200, 30];
        '1.Balanced Faults(Symmetrical):', 16, [70, 270, 250, 30];
        '- Three-phase faults (most severe but least common)', 14, [90, 240, 500, 30];
        '- All phases are equally affected', 14, [90, 210, 500, 30];
        '2.Unbalanced Faults(Asymmetrical):', 16, [70, 180, 250, 30];
        '- Line-to-ground (most common)', 14, [90, 150, 500, 30];
        '- Line-to-line', 14, [90, 120, 500, 30];
        '- Double line-to-ground', 14, [90, 90, 500, 30];
        'Why Fault Analysis is Important:', 20, [50, 60, 300, 30];
        '- Determines maximum current during faults (for equipment rating)', 14, [70, 30, 550, 30];
        '- Helps design protection systems (relays, circuit breakers)', 14, [70, 0, 550, 30];
        '- Ensures system stability and safety', 14, [70, -30, 550, 30]
    };
    
    % Add content to panel
    for i = 1:size(content, 1)
        uilabel(panel, 'Text', content{i,1}, 'FontSize', content{i,2}, ...
            'FontColor', 'white', 'FontName', 'Cambria', ...
            'Position', content{i,3}, 'HorizontalAlignment', 'left');
    end
    
    % Back button
    backButton = uibutton(fig, 'Text', 'Back to Main', ...
        'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Cambria', ...
        'Position', [340, 10, 120, 30], 'BackgroundColor', [0.8, 0.2, 0.2], ...
        'FontColor', 'white');
    
    backButton.ButtonPushedFcn = @(~, ~) faultAnalysisApp();
end

function showBalancedFaultTheory(fig)
    % Create a new figure for theory
    theoryFig = uifigure('Name', 'Balanced Fault Theory', 'Position', [200, 200, 600, 500], ...
        'Color', [0.05, 0.05, 0.05]);
    
    % Create scrollable panel
    panel = uipanel(theoryFig, 'Position', [10, 10, 580, 480], ...
        'BackgroundColor', [0.1, 0.1, 0.1], 'Scrollable', 'on');
    
    % Theory content
    content = {
        'Balanced (Symmetrical) Fault', 22, [150, 450, 350, 40];
        'What is a Balanced Fault?', 18, [50, 400, 250, 30];
        'Affects all 3 phases equally,commonly all 3 phases short-circuited', 14, [50, 350, 500, 60];
        'Characteristics:', 18, [50, 300, 200, 30];
        '- All phases see equal fault current magnitude', 14, [70, 270, 500, 30];
        '- Phase angles remain 120° apart', 14, [70, 240, 500, 30];
        '- Most severe in terms of fault current magnitude', 14, [70, 210, 500, 30];
        'Analysis Method:', 18, [50, 180, 200, 30];
        'These faults are analyzed by +ve sequence network only, calculations:', 14, [70, 150, 500, 30];
        'If = V / (Z1 + Zf)', 16, [200, 120, 200, 30];
        'Where:', 14, [70, 90, 100, 30];
        'V = System voltage', 14, [90, 60, 300, 30];
        'Z1 = Positive sequence impedance', 14, [90, 30, 300, 30];
        'Zf = Fault impedance', 14, [90, 0, 300, 30];
    };
    
    % Add content to panel
    for i = 1:size(content, 1)
        uilabel(panel, 'Text', content{i,1}, 'FontSize', content{i,2}, ...
            'FontColor', 'white', 'FontName', 'Cambria', ...
            'Position', content{i,3}, 'HorizontalAlignment', 'left');
    end
    
    % Close button
    closeButton = uibutton(theoryFig, 'Text', 'Close', ...
        'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Cambria', ...
        'Position', [240, 10, 120, 30], 'BackgroundColor', [0.8, 0.2, 0.2], ...
        'FontColor', 'white');
    
    closeButton.ButtonPushedFcn = @(~, ~) delete(theoryFig);
end

function showUnbalancedFaultTheory(fig)
    % Create a new figure for theory
    theoryFig = uifigure('Name', 'Unbalanced Fault Theory', 'Position', [200, 200, 600, 550], ...
        'Color', [0.05, 0.05, 0.05]);
    
    % Create scrollable panel
    panel = uipanel(theoryFig, 'Position', [10, 10, 580, 530], ...
        'BackgroundColor', [0.1, 0.1, 0.1], 'Scrollable', 'on');
    
    % Theory content
    content = {
        'Unbalanced(Asymmetrical) Fault', 22, [125, 500, 350, 40];
        'What are Unbalanced Faults?', 18, [50, 450, 250, 30];
        'Faults affecting the three phases unequally,more common than balanced faults', 14, [50, 400, 500, 60];
        '1. Line-to-Ground (LG) - Most common (70-80% of faults)', 16, [70, 360, 500, 30];
        '2. Line-to-Line (LL)', 16, [70, 330, 500, 30];
        '3. Double Line-to-Ground (LLG)', 16, [70, 300, 500, 30];
        'Analysis Method:', 18, [50, 270, 200, 30];
        'Unbalanced faults are analyzed using symmetrical components:', 14, [70, 240, 500, 30];
        '- Positive sequence network (normal operation)', 14, [90, 210, 500, 30];
        '- Negative sequence network (phase unbalance)', 14, [90, 180, 500, 30];
        '- Zero sequence network (ground current)', 14, [90, 150, 500, 30];
        'Key Formulas:', 18, [50, 120, 200, 30];
        'Line-to-Ground: If = 3V / (Z1 + Z2 + Z0 + 3Zf)', 14, [70, 90, 500, 30];
        'Line-to-Line: If = √3V / (Z1 + Z2 + Zf)', 14, [70, 60, 500, 30];
        'Double Line-to-Ground: More complex, depends on Z1, Z2, Z0', 14, [70, 30, 500, 30];
    };
    
    % Add content to panel
    for i = 1:size(content, 1)
        uilabel(panel, 'Text', content{i,1}, 'FontSize', content{i,2}, ...
            'FontColor', 'white', 'FontName', 'Cambria', ...
            'Position', content{i,3}, 'HorizontalAlignment', 'left');
    end
    
    % Close button
    closeButton = uibutton(theoryFig, 'Text', 'Close', ...
        'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Cambria', ...
        'Position', [240, 10, 120, 30], 'BackgroundColor', [0.8, 0.2, 0.2], ...
        'FontColor', 'white');
    
    closeButton.ButtonPushedFcn = @(~, ~) delete(theoryFig);
end

function showSpecificFaultTheory(fig, faultType)
    % Create a new figure for theory
    theoryFig = uifigure('Name', [faultType ' Fault Theory'], 'Position', [200, 200, 600, 500], ...
        'Color', [0.05, 0.05, 0.05]);
    
    % Create scrollable panel
    panel = uipanel(theoryFig, 'Position', [10, 10, 580, 480], ...
        'BackgroundColor', [0.1, 0.1, 0.1], 'Scrollable', 'on');
    
    % Content based on fault type
    switch faultType
        case 'LG'
            titleText = 'Line-to-Ground (LG) Fault';
            description = {
                'Most common fault type (70-80% of all faults)', 14, [70, 400, 500, 30];
                'Occurs when one phase makes contact with ground', 14, [70, 370, 500, 30];
                'Key Characteristics:', 16, [50, 340, 200, 30];
                '- Only one phase carries fault current', 14, [70, 310, 500, 30];
                '- Zero sequence current flows', 14, [70, 280, 500, 30];
                '- Can cause voltage rise in healthy phases', 14, [70, 250, 500, 30];
                'Analysis:', 16, [50, 220, 200, 30];
                'All three sequence networks are connected in series:', 14, [70, 190, 500, 30];
                'If = 3V / (Z1 + Z2 + Z0 + 3Zf)', 16, [200, 160, 300, 30];
                'Protection Considerations:', 16, [50, 130, 250, 30];
                '- Ground fault relays are essential', 14, [70, 100, 500, 30];
                '- Sensitive to system grounding method', 14, [70, 70, 500, 30];
                '- May require neutral grounding resistors', 14, [70, 40, 500, 30]
            };
        case 'LL'
            titleText = 'Line-to-Line (LL) Fault';
            description = {
                'Occurs when two phases make contact', 14, [70, 400, 500, 30];
                'No ground involvement in pure LL faults', 14, [70, 370, 500, 30];
                'Key Characteristics:', 16, [50, 340, 200, 30];
                '- No zero sequence current', 14, [70, 310, 500, 30];
                '- Fault current flows between two phases', 14, [70, 280, 500, 30];
                '- Voltage imbalance occurs', 14, [70, 250, 500, 30];
                'Analysis:', 16, [50, 220, 200, 30];
                'Positive and negative sequence networks are connected in parallel:', 14, [70, 190, 500, 30];
                'If = √3V / (Z1 + Z2 + Zf)', 16, [200, 160, 300, 30];
                'Protection Considerations:', 16, [50, 130, 250, 30];
                '- Phase protection relays will detect', 14, [70, 100, 500, 30];
                '- Less severe than LG faults in grounded systems', 14, [70, 70, 500, 30];
                '- Can evolve into LLG fault if arcing occurs', 14, [70, 40, 500, 30]
            };
        case 'LLG'
            titleText = 'Double Line-to-Ground(LLG) Fault';
            description = {
                'Occurs when two phases contact ground simultaneously', 14, [70, 400, 500, 30];
                'Combination of LL and LG fault characteristics', 14, [70, 370, 500, 30];
                'Key Characteristics:', 16, [50, 340, 200, 30];
                '- Two phases carry fault current', 14, [70, 310, 500, 30];
                '- Zero sequence current flows', 14, [70, 280, 500, 30];
                '- Most complex unbalanced fault to analyze', 14, [70, 250, 500, 30];
                'Analysis:', 16, [50, 220, 200, 30];
                '+ve sequence network in series with parallel combination of (-ve,0) Seq. N/W :', 14, [70, 190, 500, 30];
                'If = V / [Z1 + (Z2‖(Z0+3Zf))]', 16, [200, 160, 300, 30];
                'Protection Considerations:', 16, [50, 130, 250, 30];
                '- Requires both phase and ground protection', 14, [70, 100, 500, 30];
                '- Can cause significant equipment damage', 14, [70, 70, 500, 30];
                '- May require special protection schemes', 14, [70, 40, 500, 30]
            };
    end
    
    % Add title
    uilabel(panel, 'Text', titleText, 'FontSize', 22, ...
        'FontColor', 'white', 'FontName', 'Cambria', ...
        'Position', [150, 450, 350, 40], 'HorizontalAlignment', 'center');
    
    % Add description
    for i = 1:size(description, 1)
        uilabel(panel, 'Text', description{i,1}, 'FontSize', description{i,2}, ...
            'FontColor', 'white', 'FontName', 'Cambria', ...
            'Position', description{i,3}, 'HorizontalAlignment', 'left');
    end
    
    % Close button
    closeButton = uibutton(theoryFig, 'Text', 'Close', ...
        'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Cambria', ...
        'Position', [240, 10, 120, 30], 'BackgroundColor', [0.8, 0.2, 0.2], ...
        'FontColor', 'white');
    
    closeButton.ButtonPushedFcn = @(~, ~) delete(theoryFig);
end