using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class ShadowBolt : Ability
    {
        public ShadowBolt()
        {
            Name = "Shadow Bolt";
            FlavorText = "A bolt of concentrated shadow energy strikes the enemy.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 9;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 5;
        }
    }
}
