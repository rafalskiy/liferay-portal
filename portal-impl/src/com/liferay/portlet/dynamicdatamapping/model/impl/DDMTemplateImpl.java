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

package com.liferay.portlet.dynamicdatamapping.model.impl;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.util.LocaleUtil;
import com.liferay.portal.kernel.util.StringBundler;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.xml.Document;
import com.liferay.portal.kernel.xml.Element;
import com.liferay.portal.kernel.xml.SAXReaderUtil;
import com.liferay.portal.model.Group;
import com.liferay.portal.model.Image;
import com.liferay.portal.service.ImageLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portal.util.PropsValues;

import java.util.Locale;

/**
 * @author Brian Wing Shun Chan
 */
public class DDMTemplateImpl extends DDMTemplateBaseImpl {

	public DDMTemplateImpl() {
	}

	public String getDefaultLanguageId() {
		Document document = null;

		try {
			document = SAXReaderUtil.read(getName());

			if (document != null) {
				Element rootElement = document.getRootElement();

				return rootElement.attributeValue("default-locale");
			}
		}
		catch (Exception e) {
		}

		Locale locale = LocaleUtil.getDefault();

		return locale.toString();
	}

	public String getSmallImageType() throws PortalException, SystemException {
		if ((_smallImageType == null) && isSmallImage()) {
			Image smallImage = ImageLocalServiceUtil.getImage(
				getSmallImageId());

			_smallImageType = smallImage.getType();
		}

		return _smallImageType;
	}

	public String getWebDavURL(ThemeDisplay themeDisplay, String webDavToken) {
		StringBundler webDavURL = new StringBundler(11);

		boolean secure = false;

		if (themeDisplay.isSecure() ||
			PropsValues.WEBDAV_SERVLET_HTTPS_REQUIRED) {

			secure = true;
		}

		String portalURL = PortalUtil.getPortalURL(
			themeDisplay.getServerName(), themeDisplay.getServerPort(), secure);

		webDavURL.append(portalURL);
		webDavURL.append(themeDisplay.getPathContext());
		webDavURL.append(StringPool.SLASH);
		webDavURL.append("webdav");

		Group group = themeDisplay.getScopeGroup();

		webDavURL.append(group.getFriendlyURL());
		webDavURL.append(StringPool.SLASH);
		webDavURL.append(webDavToken);
		webDavURL.append(StringPool.SLASH);
		webDavURL.append("Templates");
		webDavURL.append(StringPool.SLASH);

		webDavURL.append(getTemplateId());

		return webDavURL.toString();
	}

	public void setSmallImageType(String smallImageType) {
		_smallImageType = smallImageType;
	}

	private String _smallImageType;

}