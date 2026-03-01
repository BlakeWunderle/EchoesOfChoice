using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class ThornWhip : Ability
    {
        public ThornWhip()
        {
            Name = "Thorn Whip";
            FlavorText = "Lash out with a vine covered in razor-sharp thorns.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 3;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
