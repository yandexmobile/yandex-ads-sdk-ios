# AI Skills for Yandex Mobile Ads SDK

This directory contains AI-assisted skills to help developers work with the Yandex Mobile Ads SDK using AI coding assistants.

## What are Skills?

Skills are structured guides that help AI coding assistants perform complex tasks accurately. Each skill is a self-contained folder with a `SKILL.md` file at its core, along with any supporting resources needed for the task. Think of them as detailed playbooks that ensure consistent results when working with AI assistants.

## How to Use

**Step 1: Load the skill**

- **For Claude Desktop**       
Copy the desired skill folder into skills directory of your agent, for example:
```bash
cp -r Skills/migrate-yandex-ads-sdk-from-7-to-8 .claude/skills/
```

- **For Cursor IDE**       
Copy the skill folder to your project and reference `SKILL.md` file with `@`, for example:
```
@migrate-yandex-ads-sdk-from-7-to-8/SKILL.md
```
  
- Alternatively, copy and paste the content of SKILL.md and all referenced files into your conversation with the agent (but this may exceed message limits).

**Step 2: Use the prompt**

Use the prompt provided in the section below for the specific skill in your AI assistant conversation.

## Available Skills

### Migration from SDK 7.x to 8.x

**Location:** [`migrate-yandex-ads-sdk-from-7-to-8/`](migrate-yandex-ads-sdk-from-7-to-8/)

Comprehensive guide for migrating your iOS app from Yandex Mobile Ads SDK version 7.x to 8.x.

**Prompt:**
```
Migrate my project from Yandex Mobile Ads SDK 7.x to 8.x 
```

## Important Notice

**Always carefully review AI-generated changes.**     
While these skills help AI assistants perform tasks accurately, you must personally review and verify all changes made by the agent.
AI assistants can make mistakes. Human review is essential.
