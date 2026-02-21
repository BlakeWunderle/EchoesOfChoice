using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Calculate : Ability
    {
        public Calculate()
        {
            Name = "Calculate";
            FlavorText = "Analyze the enemy's structure and exploit mathematical weaknesses.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 3;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
