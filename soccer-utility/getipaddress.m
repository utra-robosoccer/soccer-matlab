% Obtain local ip
function localIp = getipaddress()

if ismac
    [~,ip] = system('ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk ''{print $2}'' ');
    localIp = strip(ip);
    fprintf('\n Local IP address is: %s \n', localIp);
elseif isunix
    % Printing only. Needs testing
    [~,ip] = system('ifconfig | grep "inet " | tail -1 | grep -Eo ''inet (addr:)?([0-9]*\.){3}[0-9]*'' | grep -Eo ''([0-9]*\.){3}[0-9]*'' | grep -v ''127.0.0.1'' ');
    localIp = strip(ip);
    fprintf('\n Local IP address is: %s \n', localIp);
elseif ispc
    % Printing only. Needs testing
    a=strread(evalc('!ipconfig -all'), '%s','delimiter','\n');
    a([strmatch('IP A',a), strmatch('IPv4 ',a)])
end

if isempty(localIp), error('Enter your computer IP address manually'); end;