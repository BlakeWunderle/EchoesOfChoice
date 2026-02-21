using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class MagicalTinkering : Ability
    {
        public MagicalTinkering()
        {
            Name = "Magical Tinkering";
            FlavorText = "Invent a way to make your abilities better. Increases magical attacks";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 2;
        }
    }
}
