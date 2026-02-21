using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Proclamation : Ability
    {
        public Proclamation()
        {
            Name = "Proclamation";
            FlavorText = "A commanding declaration that reverberates through the battlefield.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 6;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 5;
        }
    }
}
