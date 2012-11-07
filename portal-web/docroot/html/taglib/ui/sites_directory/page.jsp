<%--
/**
 * Copyright (c) 2000-2012 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/html/taglib/ui/sites_directory/init.jsp" %>

<c:if test="<%= layout != null %>">

	<%
	Group rootGroup = null;
	boolean hidden = false;

	List<Group> branchGroups = new ArrayList<Group>();

	branchGroups.add(group);
	branchGroups.addAll(group.getAncestors());

	if (levelType.equals("relative")) {
		if ((level >= 0) && (level < branchGroups.size())) {
			rootGroup = branchGroups.get(level);
		}
		else {
			rootGroup = null;
		}
	}
	else if (levelType.equals("absolute")) {
		int ancestorIndex = branchGroups.size() - level;

		if ((ancestorIndex >= 0) && (ancestorIndex < branchGroups.size())) {
			rootGroup = branchGroups.get(ancestorIndex);
		}
		else if (ancestorIndex == branchGroups.size()) {
			rootGroup = null;
		}
		else {
			hidden = true;
		}
	}
	%>

	<div class="sites-directory-taglib nav-menu">
		<c:if test="<%= !hidden %>">
			<c:choose>
				<c:when test='<%= displayStyle.equals("descriptive") || displayStyle.equals("icon") %>'>
					<c:choose>
						<c:when test="<%= Validator.isNull(portletDisplay.getId()) %>">
							<div class="portlet-msg-info">
								<liferay-ui:message arguments="<%= displayStyle %>" key="the-display-style-x-cannot-be-used-in-this-context" />
							</div>
						</c:when>
						<c:otherwise>

							<%
							PortletURL portletURL = PortletURLFactoryUtil.create(request, portletDisplay.getId(), plid, PortletRequest.RENDER_PHASE);
							%>

							<liferay-ui:search-container iteratorURL="<%= portletURL %>">

								<%
								List<Group> childGroups = null;

								if (rootGroup != null) {
									childGroups = rootGroup.getChildrenWithLayouts(true, QueryUtil.ALL_POS, QueryUtil.ALL_POS);
								}
								else {
									childGroups = GroupLocalServiceUtil.getLayoutsGroups(group.getCompanyId(), GroupConstants.DEFAULT_LIVE_GROUP_ID, true, QueryUtil.ALL_POS, QueryUtil.ALL_POS);
								}

								List<Group> visibleGroups = new UniqueList<Group>();

								for (Group childGroup : childGroups) {
									if (childGroup.hasPublicLayouts()) {
										visibleGroups.add(childGroup);
									}
									else if (GroupLocalServiceUtil.hasUserGroup(user.getUserId(), childGroup.getGroupId())) {
										visibleGroups.add(childGroup);
									}
								}
								%>

								<liferay-ui:search-container-results
									results="<%= ListUtil.subList(visibleGroups, searchContainer.getStart(), searchContainer.getEnd()) %>"
									total="<%= visibleGroups.size() %>"
								/>

								<liferay-ui:search-container-row
									className="com.liferay.portal.model.Group"
									modelVar="childGroup"
								>

									<%
									LayoutSet layoutSet = null;

									if (childGroup.hasPublicLayouts()) {
										layoutSet = childGroup.getPublicLayoutSet();
									}
									else {
										layoutSet = childGroup.getPrivateLayoutSet();
									}
									%>

									<liferay-ui:app-view-entry
										assetCategoryClassName="<%= Group.class.getName() %>"
										assetCategoryClassPK="<%= childGroup.getGroupId() %>"
										assetTagClassName="<%= Group.class.getName() %>"
										assetTagClassPK="<%= childGroup.getGroupId() %>"
										description="<%= childGroup.getDescription() %>"
										displayStyle="<%= displayStyle %>"
										showCheckbox="<%= false %>"
										thumbnailSrc='<%= themeDisplay.getPathImage() + "/layout_set_logo?img_id=" + layoutSet.getLogoId() + "&t=" + WebServerServletTokenUtil.getToken(layoutSet.getLogoId()) %>'
										title="<%= HtmlUtil.escape(childGroup.getDescriptiveName(locale)) %>"
										url="<%= PortalUtil.getGroupFriendlyURL(childGroup, !childGroup.hasPublicLayouts(), themeDisplay) %>"
									/>
								</liferay-ui:search-container-row>

								<liferay-ui:search-iterator />
							</liferay-ui:search-container>
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>

					<%
					StringBundler sb = new StringBundler();

					boolean showHierarchy = false;

					if (displayStyle.equals("list-hierarchy")) {
						showHierarchy = true;
					}

					_buildSitesList(rootGroup, group, branchGroups, themeDisplay, 1, showHierarchy, true, sb);

					String content = sb.toString();
					%>

					<%= content %>

				</c:otherwise>
			</c:choose>
		</c:if>
	</div>
</c:if>

<%!
private void _buildSitesList(Group rootGroup, Group curGroup, List<Group> branchGroups, ThemeDisplay themeDisplay, int groupLevel, boolean showHierarchy, boolean nestedChildren, StringBundler sb) throws Exception {
	List<Group> childGroups = null;

	if (rootGroup != null) {
		childGroups = rootGroup.getChildrenWithLayouts(true, QueryUtil.ALL_POS, QueryUtil.ALL_POS);
	}
	else {
		childGroups = GroupLocalServiceUtil.getLayoutsGroups(curGroup.getCompanyId(), GroupConstants.DEFAULT_LIVE_GROUP_ID, true, QueryUtil.ALL_POS, QueryUtil.ALL_POS);
	}

	List<Group> visibleGroups = new UniqueList<Group>();

	for (Group childGroup : childGroups) {
		if (childGroup.hasPublicLayouts()) {
			visibleGroups.add(childGroup);
		}
		else {
			User user = themeDisplay.getUser();

			List<Group> mySites = user.getMySites(true, QueryUtil.ALL_POS);

			if (mySites.contains(childGroup)) {
				visibleGroups.add(childGroup);
			}
		}
	}

	if (childGroups.isEmpty()) {
		return;
	}

	StringBundler tailSB = null;

	if (!nestedChildren) {
		tailSB = new StringBundler();
	}

	sb.append("<ul class=\"sites level-");
	sb.append(groupLevel);
	sb.append("\">");

	for (Group childGroup : childGroups) {
		boolean open = false;

		if (showHierarchy) {
			open = true;
		}

		String className = StringPool.BLANK;

		if (open) {
			className += "open ";
		}

		if (curGroup.getGroupId() == childGroup.getGroupId()) {
			className += "selected ";
		}

		sb.append("<li ");

		if (Validator.isNotNull(className)) {
			sb.append("class=\"");
			sb.append(className);
			sb.append("\" ");
		}

		sb.append("><a ");

		if (Validator.isNotNull(className)) {
			sb.append("class=\"");
			sb.append(className);
			sb.append("\" ");
		}

		sb.append("href=\"");
		sb.append(HtmlUtil.escapeHREF(PortalUtil.getGroupFriendlyURL(childGroup, !childGroup.hasPublicLayouts(), themeDisplay)));
		sb.append("\"> ");

		sb.append(HtmlUtil.escape(childGroup.getDescriptiveName(themeDisplay.getLocale())));

		sb.append("</a>");

		if (open) {
			StringBundler childGroupSB = null;

			if (nestedChildren) {
				childGroupSB = sb;
			}
			else {
				childGroupSB = tailSB;
			}

			_buildSitesList(childGroup, curGroup, branchGroups, themeDisplay, groupLevel + 1, showHierarchy, nestedChildren, childGroupSB);
		}

		sb.append("</li>");
	}

	sb.append("</ul>");

	if (!nestedChildren) {
		sb.append(tailSB);
	}
}
%>