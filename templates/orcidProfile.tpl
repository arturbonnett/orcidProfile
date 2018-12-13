{**
 * plugins/generic/orcidProfile/orcidProfile.tpl
 *
 * Copyright (c) 2015-2018 University of Pittsburgh
 * Copyright (c) 2014-2018 Simon Fraser University
 * Copyright (c) 2003-2018 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * ORCID Profile authorization form
 *
 *}

{capture name=orcidButton assign=orcidButton}
<button id="connect-orcid-button" class="cmp_button" onclick="return openORCID();">
	{$orcidIcon}
	{if !$orcidAuthenticated}
	ORCID iD verknüpfen
	{else}
	{translate key='plugins.generic.orcidProfile.connect'}
	{/if}
</button>
<a href="{url router="page" page="orcidapi" op="about"}">{translate key='plugins.generic.orcidProfile.about.title'}</a>
{/capture}


{capture name=orcidLink assign=orcidLink}
{if $orcidAuthenticated}
	<a href="{$orcid}" target="_blank">{$orcidIcon}{$orcid}</a>
{else}
	<a href="{$orcid}" target="_blank">{$orcid}</a>&nbsp;{$orcidButton}
{/if}
{/capture}

<script type="text/javascript">
	function createORCIDLink(orcidUrl) {ldelim}
		
		{if $orcidAuthenticated}
		var orcidIconHtml = {$orcidIcon|json_encode};
		{else}
		var orcidIconHtml = '';
		{/if}
		return '<a href="' + orcidUrl + '" target="_blank">' + orcidIconHtml + ' ' + orcidUrl + '</a>';
	{rdelim}
	function openORCID() {ldelim}
		// First sign out from ORCID to make sure no other user is logged in
		// with ORCID
		$.ajax({ldelim}
            url: '{$orcidUrl|escape}userStatus.json?logUserOut=true',
            dataType: 'jsonp',
            success: function(result,status,xhr) {ldelim}
                console.log("ORCID Logged In: " + result.loggedIn);
            {rdelim},
            error: function (xhr, status, error) {ldelim}
                console.log(status + ", error: " + error);
            {rdelim}
        {rdelim});
		var oauthWindow = window.open("{$orcidOAuthUrl}", "_blank", "toolbar=no, scrollbars=yes, width=500, height=700, top=500, left=500");
		oauthWindow.opener = self;
		return false;
	{rdelim}
{if $targetOp eq 'profile'}
	function oAuthCallback(orcidResponse) {ldelim}
		console.log(orcidResponse);
		$('#connect-orcid-button').replaceWith(createORCIDLink(orcidResponse.orcid));
		$('input[name=orcid]').prop('value', orcidResponse.orcid);
		$('#publicProfileForm').submit();
	{rdelim}
	$(document).ready(function() {ldelim}        
		var orcidInput = $('input[name=orcid]');
        orcidInput.attr('type', 'hidden');
        var orcidLinkOrButton = $(
        	{if $orcid}
        		{$orcidLink|json_encode}
        	{else}
        		{$orcidButton|json_encode}
        	{/if});       
        orcidLinkOrButton.insertAfter(orcidInput);		
	{rdelim});
{/if}
</script>

{if $targetOp eq 'register'}
	{fbvElement type="hidden" name="orcid" id="orcid" value=$orcid maxlength="37"}
	{$orcidButton}
{/if}
