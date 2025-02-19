
$(document).ready(function(){
    
    function openInNewTab(url) {
        var win = window.open(url, '_blank');
        win.focus();
    }
    
    function fetchAndFill(url, element){
        $.get(url, function(text) {
            //var lineCount = text.split(/\r\n|\r|\n/).length;
            $(element).text(text).css('color', '');
            if(typeof element.onload == "function") element.onload();
        });
    }
    
    function launchDomainSection(section){
        var $sec = $(section);
        var url = $sec.attr('data-url');
        $sec.css('color', '#999');
        var frame = this;
        var startVal = $("#domainField")[0].value;
        var domain = startVal.trim();
        if(domain.indexOf('http://') == 0) domain = domain.substr(7);
        else if(domain.indexOf('https://') == 0) domain = domain.substr(8);
        var slash = domain.indexOf('/');
        if(slash != -1) domain = domain.substr(0, slash);
        url += "?url=" + domain;
        if(url.indexOf('mail.php') != -1){
            url += "&selector=" + $('#dkim-selector')[0].value.trim();
        }
        fetchAndFill(url, section);
        if(startVal != domain) $("#domainField")[0].value = domain;
    }
    
    function launchIpSection(section){
        var url = $(section).attr('data-url');
        var startVal = $("#ipField")[0].value;
        var ip = startVal.trim();
        if(url.indexOf('imhadmin.net') != -1){
            section.innerHTML = '<iframe src="https://clarity.imhadmin.net/SearchSC.php?ip=' + ip + '"></iframe>';
        }else{
            $(section).css('color', '#999');
            fetchAndFill(url + "?ip=" + ip, section);
        if(startVal != ip) $("#ipField")[0].value = ip;
        }
    }
    
    function onLauchIpSectionClick(){ launchIpSection(this.sectionFrame); }
    function onLauchDomainSectionClick(){ launchDomainSection(this.sectionFrame); }
    
    function setupSection(clickElement, frameElement){
        clickElement.sectionFrame = frameElement;
        if($(frameElement).hasClass('domain-frame'))
            clickElement.onclick = onLauchDomainSectionClick;
        else if($(frameElement).hasClass('ip-frame'))
            clickElement.onclick = onLauchIpSectionClick;
    }
    
    // setup sections
    $('.section').each(function(){
        var clickElement = $(this).find('h3')[0];
        var frameElement = $(this).find('.frame')[0];
        setupSection(clickElement, frameElement);
    });
    
    $('#main-form').submit(function(){
        $('.domain-frame').each(function(){launchDomainSection(this);});
        return false;
    });
    
    $('#ip-form').submit(function(){
        $('.ip-frame').each(function(){launchIpSection(this);});
        return false;
    });
    
    $('#clear-ip').click(function(){
        $('.ip-frame').text('');
        $('#ipField').val('');
        return false;
    });
    
    $('#clear-domain').click(function(){
        $('.domain-frame').text('');
        $('#domainField').val('');
        $('#dkim-selector').val('default');
        return false;
    });
    
    $('#registration-section .frame').each(function(){this.onload = function(){
        var content = $(this).text().toLocaleLowerCase();
        // for status codes, see https://www.icann.org/en/system/files/files/epp-status-codes-30jun11-en.pdf
        var regEx = /(clienthold|inactive|serverHold|pendingCreate|redemptionPeriod|pendingDelete)/;
        if( content.match(regEx) ) $(this).css('color', '#B00');
    } });
    
    $('#ssl-section .frame').each(function(){this.onload = function(){
        var content = $(this).text().toLocaleLowerCase();
        var notRegEx = /verify return code: 0 /;
        var regEx = /domain not covered/;
        if( content.match(regEx) || !content.match(notRegEx) ) $(this).css('color', '#B00');
    } });
    
    $('#hostname-section .frame').each(function(){this.onload = function(){
        var content = $(this).text().toLocaleLowerCase();
        var regEx = /\*\*\* ptr mismatch \*\*\*/;
        if( content.match(regEx) ) $(this).css('color', '#B00');
    } });
    
    // $('#clarity-ip').click(function(event){
    //     event.preventDefault();
    //     var rawIp = $('#ipField').val().trim();
    //     /*
    //     var ip = encodeURIComponent(rawIp);
    //     var win = window.open('https://clarity.imhadmin.net/SearchSC.php?SearchText=' + ip + '&SearchType=I', '_blank');
    //     if (win) {
    //         win.focus();
    //     } else {
    //         alert('Please allow popups for this website');
    //     }
    //     */
    //     $.post('https://clarity.imhadmin.net/SearchSC.php', { SearchText: rawIp, SearchType: "I" })
    //         .done(function (data) {
    //             var w = window.open('about:blank');
    //             w.document.open();
    //             w.document.write(data);
    //             w.document.close();
    //         });
    //     return true;
    // });

    $("#dom-rbl").click(function(){
        var startVal = $("#domainField")[0].value;
        var addr = startVal.trim();
        openInNewTab("http://multirbl.valli.org/lookup/" + addr + ".html");
    });

    $("#rbl").click(function(){
        var startVal = $("#ipField")[0].value;
        var ip = startVal.trim();
        openInNewTab("http://multirbl.valli.org/lookup/" + ip + ".html");
    });

    $("#ssl-labs").click(function(){
        var startVal = $("#domainField")[0].value;
        var addr = startVal.trim();
        openInNewTab("https://www.ssllabs.com/ssltest/analyze.html?d=" + addr + "&latest");
    });

    $("#hsts").click(function(){
        var startVal = $("#domainField")[0].value;
        var addr = startVal.trim();
        openInNewTab("https://hstspreload.org/?domain=" + addr);
    });

    $("#whatcms").click(function(){
        var startVal = $("#domainField")[0].value;
        var addr = startVal.trim();
        openInNewTab("https://whatcms.org/?s=" + addr);
    });

    $("#gtm").click(function(){
        var startVal = $("#domainField")[0].value;
        var addr = startVal.trim();
        openInNewTab("https://gtmetrix.com/?url=" + addr);
    });
});
